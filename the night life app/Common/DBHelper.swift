import SQLite
import Foundation

class DBHelper {
    static let shared = DBHelper()
    
    private var db: Connection?
    private let venues = Table("venues")
    
    // Kolonnedefinisjoner
    private let id = SQLite.Expression<Int64>("id")
    private let name = SQLite.Expression<String>("name")
    private let type = SQLite.Expression<String>("type")
    private let image = SQLite.Expression<String>("image")
    private let isOpen = SQLite.Expression<Bool>("is_open")
    private let entryFee = SQLite.Expression<Int64?>("entry_fee")
    private let hasCoatCheck = SQLite.Expression<Bool>("has_coat_check")
    private let crowdLevel = SQLite.Expression<String>("crowd_level")
    private let musicGenre = SQLite.Expression<String>("music_genre")
    private let description = SQLite.Expression<String>("description")
    private let latitude = SQLite.Expression<Double?>("latitude")
    private let longitude = SQLite.Expression<Double?>("longitude")
    
    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            
            let dbPath = "\(path)/venues.sqlite3"
            print("Database path: \(dbPath)")
            
            // Kun opprett ny database hvis den ikke eksisterer
            let databaseExists = FileManager.default.fileExists(atPath: dbPath)
            
            db = try Connection(dbPath)
            
            if !databaseExists {
                print("Oppretter ny database")
                createTable()
            }
        } catch {
            print("Database initialization error: \(error)")
        }
    }
    

    private func createTable() {
        do {
            try db?.run(venues.create(ifNotExists: true, block:  { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(name)
                table.column(type)
                table.column(image)
                table.column(isOpen, defaultValue: true)
                table.column(entryFee)
                table.column(hasCoatCheck, defaultValue: false)
                table.column(crowdLevel)
                table.column(musicGenre)
                table.column(description)
                table.column(latitude, defaultValue: nil)
                table.column(longitude, defaultValue: nil)
            })
        )} catch {
            print("Table creation error: \(error)")
        }
    }
    
    // CRUD Operations
    func insertVenue(_ venue: Venue) -> Bool {
        do {
            let insert = venues.insert(
                name <- venue.name,
                type <- venue.type.rawValue,
                image <- venue.images.first ?? "",
                isOpen <- venue.isOpen,
                entryFee <- venue.entryFee.map { Int64($0) },
                hasCoatCheck <- venue.hasCoatCheck,
                crowdLevel <- venue.crowdLevel.rawValue,
                musicGenre <- venue.musicGenre,
                description <- venue.description,
                latitude <- venue.latitude ?? 0.0,
                longitude <- venue.longitude ?? 0.0
            )
            
            try db?.run(insert)
            return true
        } catch {
            print("Insert error: \(error)")
            return false
        }
    }
    
    func fetchVenues() -> [Venue] {
        var venueList: [Venue] = []
        
        do {
            guard let db = db else { return [] }
            
            for venue in try db.prepare(venues) {
                if let venueType = VenueType(rawValue: venue[type]) {
                    // Spesifiserer typen eksplisitt for å unngå tvetydighet
                    let crowdLevelEnum = Venue.CrowdLevel(rawValue: venue[crowdLevel]) ?? .medium
                    
                    let venueObject = Venue(
                        id: Int(venue[id]),
                        name: venue[name],
                        type: venueType,
                        images: [venue[image]],
                        isOpen: venue[isOpen],
                        ageLimit: 18,
                        entryFee: venue[entryFee].map { Int($0) },
                        hasCoatCheck: venue[hasCoatCheck],
                        musicGenre: venue[musicGenre],
                        crowdLevel: crowdLevelEnum,
                        description: venue[description],
                        latitude: venue[latitude],
                        longitude: venue[longitude]
                    )
                    venueList.append(venueObject)
                }
            }
        } catch {
            print("Fetch error: \(error)")
        }
        
        return venueList
    }
    
    func updateVenue(_ venue: Venue) -> Bool {
        do {
            let venueRecord = venues.filter(id == Int64(venue.id))
            
            try db?.run(venueRecord.update(
                name <- venue.name,
                type <- venue.type.rawValue,
                image <- venue.images.first ?? "",
                isOpen <- venue.isOpen,
                entryFee <- venue.entryFee.map { Int64($0) },
                hasCoatCheck <- venue.hasCoatCheck,
                crowdLevel <- venue.crowdLevel.rawValue,
                musicGenre <- venue.musicGenre,
                description <- venue.description,
                latitude <- venue.latitude ?? 0.0,
                longitude <- venue.longitude ?? 0.0
            ))
            
            return true
        } catch {
            print("Update error: \(error)")
            return false
        }
    }
    
    func deleteVenue(id venueId: Int) -> Bool {
        do {
            let venueRecord = venues.filter(id == Int64(venueId))
            try db?.run(venueRecord.delete())
            return true
        } catch {
            print("Delete error: \(error)")
            return false
        }
    }
}

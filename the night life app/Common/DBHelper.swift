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
    
    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
        
            print("Database path: \(path)/venues.sqlite3") 
             // Legg til denne linjen
            db = try Connection("\(path)/venues.sqlite3")
            createTable()
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
                description <- venue.description
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
                if let venueType = VenueType(rawValue: venue[type]),
                   let crowdLevelEnum = Venue.CrowdLevel(rawValue: venue[crowdLevel]) {
                    
                    let venueObject = Venue(
                        id: Int(venue[id]),
                        name: venue[name],
                        type: venueType,
                        images: [venue[image]],
                        isOpen: venue[isOpen],
                        ageLimit: 18, // Dette bør legges til i databasen
                        entryFee: venue[entryFee].map { Int($0) },
                        hasCoatCheck: venue[hasCoatCheck],
                        musicGenre: venue[musicGenre],
                        crowdLevel: crowdLevelEnum,
                        description: venue[description]
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
                description <- venue.description
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

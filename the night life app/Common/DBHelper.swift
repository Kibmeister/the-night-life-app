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
            
            // Slett eksisterende database for å tvinge reinitialisering
            try? FileManager.default.removeItem(atPath: dbPath)
            
            db = try Connection(dbPath)
            print("Oppretter ny database og initialiserer venues...")
            createTable()
            initializeVenues()
            
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
    
    private func initializeVenues() {
        let venues = [
            Venue(
                id: 1,
                name: "The Villa",
                type: .nightclub,
                image: "villa_image",
                isOpen: true,
                ageLimit: 23,
                entryFee: 200,
                hasCoatCheck: true,
                musicGenre: "House/Techno",
                crowdLevel: .high,
                description: "Oslos mest eksklusive nattklubb med fokus på elektronisk musikk.",
                latitude: 59.91657,
                longitude: 10.74926
            ),
            Venue(
                id: 2,
                name: "Blå",
                type: .nightclub,
                image: "blaa_image",
                isOpen: true,
                ageLimit: 20,
                entryFee: 150,
                hasCoatCheck: true,
                musicGenre: "Jazz/Electronic",
                crowdLevel: .medium,
                description: "Legendarisk venue kjent for jazz og elektronisk musikk.",
                latitude: 59.91829,
                longitude: 10.75246
            ),
            Venue(
                id: 3,
                name: "Kulturhuset",
                type: .bar,
                image: "kulturhuset_image",
                isOpen: true,
                ageLimit: 20,
                entryFee: nil,
                hasCoatCheck: true,
                musicGenre: "Variert",
                crowdLevel: .medium,
                description: "Seks etasjer med ulike barer og aktiviteter.",
                latitude: 59.91461,
                longitude: 10.74872
            ),
            Venue(
                id: 4,
                name: "Tilt",
                type: .arcade,
                image: "tilt_image",
                isOpen: true,
                ageLimit: 20,
                entryFee: nil,
                hasCoatCheck: false,
                musicGenre: "Rock/Pop",
                crowdLevel: .medium,
                description: "Spillbar med flipperspill, arkadespill og godt utvalg av øl.",
                latitude: 59.91616,
                longitude: 10.74099
            ),
            Venue(
                id: 5,
                name: "Jaeger",
                type: .nightclub,
                image: "jaeger_image",
                isOpen: true,
                ageLimit: 21,
                entryFee: 150,
                hasCoatCheck: true,
                musicGenre: "Techno/House",
                crowdLevel: .high,
                description: "Underground nattklubb med fokus på elektronisk musikk.",
                latitude: 59.91461,
                longitude: 10.75016
            )
        ]
        
        for venue in venues {
            _ = insertVenue(venue)
        }
    }
    
    // CRUD Operations
    func insertVenue(_ venue: Venue) -> Bool {
        do {
            let insert = venues.insert(
                name <- venue.name,
                type <- venue.type.rawValue,
                image <- venue.image,
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
                    let crowdLevelEnum = Venue.CrowdLevel(rawValue: venue[crowdLevel]) ?? .medium
                    
                    let venueObject = Venue(
                        id: Int(venue[id]),
                        name: venue[name],
                        type: venueType,
                        image: venue[image],
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
                image <- venue.image,
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
    
    func updateVenueLocation(id venueId: Int, latitude: Double, longitude: Double) -> Bool {
        do {
            let venueRecord = venues.filter(self.id == Int64(venueId))
            try db?.run(venueRecord.update(
                self.latitude <- latitude,
                self.longitude <- longitude
            ))
            return true
        } catch {
            print("Update location error: \(error)")
            return false
        }
    }
    
    // Funksjon for å oppdatere alle lokasjoner
    func updateAllLocations() {
        // The Villa - Møllergata 23
        updateVenueLocation(id: 1, latitude: 59.91657, longitude: 10.74926)
        
        // Blå - Brenneriveien 9C
        updateVenueLocation(id: 2, latitude: 59.91829, longitude: 10.75246)
        
        // Kulturhuset - Youngstorget 3
        updateVenueLocation(id: 3, latitude: 59.91461, longitude: 10.74872)
        
        // Tilt - Torggata 16
        updateVenueLocation(id: 4, latitude: 59.91616, longitude: 10.74099)
        
        // Jaeger - Grensen 9
        updateVenueLocation(id: 5, latitude: 59.91461, longitude: 10.75016)
    }
}

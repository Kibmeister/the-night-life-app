import SwiftUI

class VenueViewModel: ObservableObject {
    @Published private(set) var venues: [Venue] = []
    @Published private(set) var filteredVenues: [Venue] = []
    private let dbHelper = DBHelper.shared
    private let storageService = StorageService.shared
    
    // Cache for bilde-URLer
    private let defaults = UserDefaults.standard
    private let imageUrlsCacheKey = "venueImageUrls"
    
    init() {
        // Last venues fra databasen
        loadVenues()
        
        // Hvis databasen er tom, populer den
        if venues.isEmpty {
            Task {
                await populateInitialData()
            }
        }
    }
    
    private func loadVenues() {
        venues = dbHelper.fetchVenues()
        filteredVenues = venues
        print("Antall venues lastet: \(venues.count)")
    }
    
    private func saveImageUrlToCache(venueName: String, url: String) {
        var cache = defaults.dictionary(forKey: imageUrlsCacheKey) as? [String: String] ?? [:]
        cache[venueName] = url
        defaults.set(cache, forKey: imageUrlsCacheKey)
    }
    
    private func getImageUrlFromCache(venueName: String) -> String? {
        let cache = defaults.dictionary(forKey: imageUrlsCacheKey) as? [String: String]
        return cache?[venueName]
    }
    
    // Ny funksjon som kan kalles manuelt når vi trenger å oppdatere data
    func populateInitialData() async {
        print("Starter populering av database...")
        
        let newVenues = [
            (venue: Venue(id: 1,
                         name: "Kulturhuset",
                         type: .bar,
                         images: [],
                         isOpen: true,
                         ageLimit: 20,
                         entryFee: 50,
                         hasCoatCheck: true,
                         musicGenre: "House/Techno",
                         crowdLevel: .high,
                         description: "Populært kulturhus med flere etasjer og forskjellige barer",
                         latitude: 59.9137,
                         longitude: 10.7516),
             imageName: "kulturhuset_image"),
            
            (venue: Venue(id: 2,
                         name: "Blå",
                         type: .pub,
                         images: [],
                         isOpen: true,
                         ageLimit: 20,
                         entryFee: nil,
                         hasCoatCheck: true,
                         musicGenre: "Jazz/Live",
                         crowdLevel: .medium,
                         description: "Legendarisk jazzklubb og konsertsted ved Akerselva",
                         latitude: 59.9201,
                         longitude: 10.7524),
             imageName: "blaa_image"),
            
            (venue: Venue(id: 3,
                         name: "The Villa",
                         type: .disco,
                         images: [],
                         isOpen: true,
                         ageLimit: 21,
                         entryFee: 200,
                         hasCoatCheck: true,
                         musicGenre: "Electronic/House",
                         crowdLevel: .high,
                         description: "Oslos beste nattklubb for elektronisk musikk",
                         latitude: 59.9133,
                         longitude: 10.7506),
             imageName: "villa_image"),
            
            (venue: Venue(id: 4,
                         name: "Tilt",
                         type: .arcade,
                         images: [],
                         isOpen: true,
                         ageLimit: 18,
                         entryFee: nil,
                         hasCoatCheck: false,
                         musicGenre: "Retro Gaming",
                         crowdLevel: .medium,
                         description: "Spillbar med arkadespill og flipperspill",
                         latitude: 59.9145,
                         longitude: 10.7505),
             imageName: "tilt_image"),
            
            (venue: Venue(id: 5,
                         name: "Jaeger",
                         type: .disco,
                         images: [],
                         isOpen: true,
                         ageLimit: 20,
                         entryFee: 150,
                         hasCoatCheck: true,
                         musicGenre: "Techno/House",
                         crowdLevel: .high,
                         description: "Underground nattklubb med topp lydanlegg",
                         latitude: 59.9156,
                         longitude: 10.7516),
             imageName: "jaeger_image"),
            
            (venue: Venue(id: 6,
                         name: "Dattera til Hagen",
                         type: .bar,
                         images: [],
                         isOpen: true,
                         ageLimit: 20,
                         entryFee: nil,
                         hasCoatCheck: false,
                         musicGenre: "Indie/Alternative",
                         crowdLevel: .medium,
                         description: "Koselig bar med uteservering og god stemning",
                         latitude: 59.9167,
                         longitude: 10.7528),
             imageName: "dattera_image"),
            
            (venue: Venue(id: 7,
                         name: "Oslo Mekaniske Verksted",
                         type: .pub,
                         images: [],
                         isOpen: true,
                         ageLimit: 20,
                         entryFee: nil,
                         hasCoatCheck: true,
                         musicGenre: "Ambient/Chill",
                         crowdLevel: .low,
                         description: "Historisk pub i gamle industrilokaler",
                         latitude: 59.9172,
                         longitude: 10.7515),
             imageName: "mekaniske_image"),
            
            (venue: Venue(id: 8,
                         name: "The Reef",
                         type: .bar,
                         images: [],
                         isOpen: true,
                         ageLimit: 20,
                         entryFee: 100,
                         hasCoatCheck: true,
                         musicGenre: "Pop/RnB",
                         crowdLevel: .high,
                         description: "Populær sports- og partybar i sentrum",
                         latitude: 59.9142,
                         longitude: 10.7535),
             imageName: "reef_image"),
            
            (venue: Venue(id: 9,
                         name: "Elsker",
                         type: .disco,
                         images: [],
                         isOpen: true,
                         ageLimit: 20,
                         entryFee: 150,
                         hasCoatCheck: true,
                         musicGenre: "Pop/Dance",
                         crowdLevel: .high,
                         description: "LHBT+-vennlig nattklubb med god stemning",
                         latitude: 59.9147,
                         longitude: 10.7498),
             imageName: "elsker_image"),
            
            (venue: Venue(id: 10,
                         name: "Himkok",
                         type: .bar,
                         images: [],
                         isOpen: true,
                         ageLimit: 20,
                         entryFee: nil,
                         hasCoatCheck: false,
                         musicGenre: "Lounge/Jazz",
                         crowdLevel: .medium,
                         description: "Prisbelønnet cocktailbar med unik atmosfære",
                         latitude: 59.9161,
                         longitude: 10.7509),
             imageName: "himkok_image")
        ]
        
        if dbHelper.fetchVenues().isEmpty {
            for (venue, imageName) in newVenues {
                if let image = UIImage(named: imageName) {
                    // Sjekk først om vi har URL-en i cache
                    if let cachedUrl = getImageUrlFromCache(venueName: venue.name) {
                        var venueWithImage = venue
                        venueWithImage.images = [cachedUrl]
                        let success = dbHelper.insertVenue(venueWithImage)
                        print("Bruker cachet bilde-URL for \(venue.name)")
                    } else {
                        // Last opp bilde kun hvis vi ikke har URL-en i cache
                        do {
                            let imageUrl = try await storageService.uploadImage(image, venueName: venue.name)
                            saveImageUrlToCache(venueName: venue.name, url: imageUrl)
                            var venueWithImage = venue
                            venueWithImage.images = [imageUrl]
                            let success = dbHelper.insertVenue(venueWithImage)
                            print("Lastet opp bilde for \(venue.name): \(success ? "suksess" : "feilet")")
                        } catch {
                            print("Feil ved opplasting av bilde for \(venue.name): \(error)")
                        }
                    }
                }
            }
            
            await MainActor.run {
                loadVenues()
            }
            
            print("Database populering fullført")
        }
    }
    
    func filterVenues(by type: VenueType?) {
        if let type = type {
            filteredVenues = venues.filter { $0.type == type }
        } else {
            filteredVenues = venues
        }
    }
    
    // Legg til ny metode for å laste opp bilde
    func uploadVenueImage(_ image: UIImage, for venue: Venue) async throws -> String {
        return try await storageService.uploadImage(image, venueName: venue.name)
    }
    
    // Oppdater venue med ny bilde-URL
    func updateVenueImage(_ venue: Venue, with imageUrl: String) {
        var updatedVenue = venue
        updatedVenue.images = [imageUrl]
        _ = dbHelper.updateVenue(updatedVenue)
        loadVenues()  // Oppdater venues liste
    }
} 


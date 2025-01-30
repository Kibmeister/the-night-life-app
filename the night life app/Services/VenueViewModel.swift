import SwiftUI

class VenueViewModel: ObservableObject {
    @Published private(set) var venues: [Venue] = []
    @Published private(set) var filteredVenues: [Venue] = []
    private let dbHelper = DBHelper.shared
    private let storageService = StorageService.shared
    
    init() {
        // Test at bildene er tilgjengelige
        for imageName in ["kulturhuset_image", "blaa_image", "villa_image", "tilt_image", 
                         "jaeger_image", "dattera_image", "mekaniske_image", "reef_image", 
                         "elsker_image", "himkok_image"] {
            if UIImage(named: imageName) != nil {
                print("✅ Fant bilde: \(imageName)")
            } else {
                print("❌ Mangler bilde: \(imageName)")
            }
        }
        
        // Last først eksisterende venues fra databasen
        loadVenues()
        
        // Hvis det ikke finnes noen venues, populer databasen
        if venues.isEmpty {
            Task {
                await populateVenuesWithImages()
                await MainActor.run {
                    loadVenues()
                }
            }
        }
    }
    
    private func loadVenues() {
        venues = dbHelper.fetchVenues()
        filteredVenues = venues
        print("Antall venues lastet: \(venues.count)")  // Debug print
    }
    
    @MainActor
    private func populateVenuesWithImages() async {
        print("Starter populering av database...")  // Debug print
        
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
                         description: "Populært kulturhus med flere etasjer og forskjellige barer"),
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
                         description: "Legendarisk jazzklubb og konsertsted ved Akerselva"),
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
                         description: "Oslos beste nattklubb for elektronisk musikk"),
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
                         description: "Spillbar med arkadespill og flipperspill"),
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
                         description: "Underground nattklubb med topp lydanlegg"),
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
                         description: "Koselig bar med uteservering og god stemning"),
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
                         description: "Historisk pub i gamle industrilokaler"),
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
                         description: "Populær sports- og partybar i sentrum"),
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
                         description: "LHBT+-vennlig nattklubb med god stemning"),
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
                         description: "Prisbelønnet cocktailbar med unik atmosfære"),
             imageName: "himkok_image")
        ]
        
        // Slett eksisterende data
        for venue in dbHelper.fetchVenues() {
            _ = dbHelper.deleteVenue(id: venue.id)
        }
        
        // Last opp bilder og lagre venues
        for (venue, imageName) in newVenues {
            if let image = UIImage(named: imageName) {
                do {
                    let imageUrl = try await storageService.uploadImage(image, venueName: venue.name)
                    var venueWithImage = venue
                    venueWithImage.images = [imageUrl]
                    let success = dbHelper.insertVenue(venueWithImage)
                    print("Lastet opp bilde for \(venue.name): \(success ? "suksess" : "feilet")")
                } catch {
                    print("Feil ved opplasting av bilde for \(venue.name): \(error)")
                }
            } else {
                print("Fant ikke bilde: \(imageName)")
            }
        }
        
        print("Database populering fullført")  // Debug print
    }
    
    func filterVenues(by type: VenueType?) {
        if let type = type {
            filteredVenues = venues.filter { $0.type == type }
        } else {
            filteredVenues = venues
        }
        print("Filtrerte venues: \(filteredVenues.count)")  // Debug print
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

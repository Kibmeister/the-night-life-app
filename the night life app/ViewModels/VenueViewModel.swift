import CoreLocation
import SwiftUI

class VenueViewModel: ObservableObject {
    @Published var venues: [Venue] = []
    @Published var filteredVenues: [Venue] = []
    @StateObject private var locationManager = LocationManager()
    private let dbHelper = DBHelper.shared
    
    init() {
        // Oppdater lokasjoner først
        dbHelper.updateAllLocations()
        // Deretter last venues
        loadVenues()
    }
    
    private func loadVenues() {
        // Hent venues fra databasen
        venues = dbHelper.fetchVenues()
        // Initialiser filteredVenues med alle venues
        filteredVenues = venues
        
        // Detaljert debug utskrift
        print("\n=== VENUES I DATABASEN ===")
        venues.forEach { venue in
            print("""
                  ID: \(venue.id)
                  Navn: \(venue.name)
                  Type: \(venue.type.rawValue)
                  Koordinater: \(venue.latitude ?? 0), \(venue.longitude ?? 0)
                  ----------------------
                  """)
        }
    }
    
    func calculateDistance(to venue: Venue) -> Double {
        guard let userLocation = locationManager.userLocation,
              let venueLat = venue.latitude,
              let venueLong = venue.longitude else {
            return Double.infinity
        }
        
        let venueLocation = CLLocation(latitude: venueLat, longitude: venueLong)
        return userLocation.distance(from: venueLocation)
    }
    
    func filterVenues(by type: VenueType?) {
        switch type {
        case .nearest:
            filteredVenues = venues.sorted { venue1, venue2 in
                calculateDistance(to: venue1) < calculateDistance(to: venue2)
            }
        case .bar, .nightclub, .pub, .disco, .arcade:
            filteredVenues = venues.filter { $0.type == type }
        case .all, .none:
            filteredVenues = venues
        }
        
        // Debug utskrift
        print("Filtered venues count: \(filteredVenues.count)")
    }
} 
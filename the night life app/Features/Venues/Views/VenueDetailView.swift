import CoreLocation
import SwiftUI
import Inject

struct VenueImageView: View {
    let imageUrl: String
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else {
                    Color.gray.opacity(0.2)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .onAppear {
                            imageLoader.load(from: imageUrl)
                        }
                }
            }
        }
        .onDisappear {
            imageLoader.cancel()
        }
    }
}

struct VenueDetailView: View {
    @ObserveInjection var inject
    let venue: Venue
    @StateObject private var locationManager = LocationManager()
    
    private func formatDistance() -> String {
        guard let userLocation = locationManager.userLocation,
              let venueLat = venue.latitude,
              let venueLong = venue.longitude else {
            return "Ukjent avstand"
        }
        
        let venueLocation = CLLocation(latitude: venueLat, longitude: venueLong)
        let distanceInMeters = userLocation.distance(from: venueLocation)
        
        if distanceInMeters < 1000 {
            return String(format: "%.0fm unna", distanceInMeters)
        } else {
            let distanceInKm = distanceInMeters / 1000
            return String(format: "%.1fkm unna", distanceInKm)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Bildegalleri
                VenueImageView(imageUrl: venue.image)
                    .frame(height: 300)
                
                // Informasjon
                VStack(alignment: .leading, spacing: 16) {
                    // Navn og tags
                    VStack(alignment: .leading, spacing: 8) {
                        Text(venue.name)
                            .font(.title)
                            .bold()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                Group {
                                    StatusTag(text: venue.isOpen ? "Åpen" : "Stengt", 
                                            isActive: venue.isOpen)
                                    StatusTag(text: venue.type.rawValue, isActive: true)
                                    StatusTag(text: "\(venue.ageLimit)+", isActive: true)
                                    StatusTag(text: formatDistance(), isActive: true)
                                    if let fee = venue.entryFee {
                                        StatusTag(text: "Inngang: \(fee)kr", isActive: true)
                                    }
                                    StatusTag(text: venue.hasCoatCheck ? "Garderobe" : "Ingen garderobe", 
                                            isActive: venue.hasCoatCheck)
                                }
                            }
                        }
                    }
                    
                    CrowdLevelIndicator(level: venue.crowdLevel)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dagens musikk")
                            .font(.headline)
                        Text(venue.musicGenre)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Om stedet")
                            .font(.headline)
                        Text(venue.description)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .enableInjection()
    }
}

// Preview
struct VenueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VenueDetailView(venue: Venue(
                id: 1,
                name: "Test Venue",
                type: .bar,
                image: "venue_placeholder",
                isOpen: true,
                ageLimit: 20,
                entryFee: 100,
                hasCoatCheck: true,
                musicGenre: "Pop/Rock",
                crowdLevel: .medium,
                description: "Et koselig sted i hjertet av byen med god stemning og kalde drikker.",
                latitude: 59.9139,
                longitude: 10.7522
            ))
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        // Hardkoder brukerens posisjon til Kirkegata 8, Oslo
        let kirkegata8 = CLLocation(
            latitude: 59.91127,  // Kirkegata 8 koordinater
            longitude: 10.74611
        )
        userLocation = kirkegata8
    }
    
    // Vi kan beholde disse metodene for fremtidig bruk
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Ignorerer faktiske lokasjonsoppdateringer siden vi bruker hardkodet lokasjon
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
    }
} 
import SwiftUI
import CoreLocation

struct VenueMapPreview: View {
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
        NavigationLink(destination: VenueDetailView(venue: venue)) {
            VStack(spacing: 0) {
                // Informasjonscontainer
                VStack(alignment: .leading, spacing: 8) {
                    Text(venue.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            StatusTag(text: venue.type.rawValue, isActive: true)
                            StatusTag(text: "\(venue.ageLimit)+", isActive: true)
                            StatusTag(text: formatDistance(), isActive: true)
                            if let fee = venue.entryFee {
                                StatusTag(text: "\(fee)kr", isActive: true)
                            }
                            StatusTag(text: venue.isOpen ? "Åpen" : "Stengt", 
                                    isActive: venue.isOpen)
                        }
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12, corners: [.topLeft, .topRight])
        }
        .buttonStyle(PlainButtonStyle())  // Beholder standard touch feedback
    }
}

// Hjelpefunksjon for å sette corner radius på spesifikke hjørner
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
} 
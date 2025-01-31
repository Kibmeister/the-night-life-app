import SwiftUI
import CoreLocation

struct VenueCard: View {
    let venue: Venue
    @StateObject private var locationManager = LocationManager()
    @State private var cachedImage: UIImage?
    
    // Hjelpefunksjon for å formatere avstanden
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
                // Bakgrunnsbilde
                if let firstImage = venue.images.first {
                    if let cached = cachedImage {
                        Image(uiImage: cached)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 340)
                            .clipped()
                    } else {
                        AsyncImage(url: URL(string: firstImage)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 340)
                                .clipped()
                                .onAppear {
                                    // Cache bildet når det lastes
                                    if let data = try? Data(contentsOf: URL(string: firstImage)!),
                                       let image = UIImage(data: data) {
                                        cachedImage = image
                                    }
                                }
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                    }
                }
                
                // Informasjonscontainer
                VStack(alignment: .leading, spacing: 12) {
                    // Tittel i full bredde
                    Text(venue.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)  // Sikrer at tittelen tar full bredde
                    
                    // Tags container med scrolling
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            // Venstre-alignede tags i en ScrollView
                            ScrollView(.horizontal, showsIndicators: false) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        StatusTag(text: venue.type.rawValue, isActive: true)
                                        StatusTag(text: "\(venue.ageLimit)+", isActive: true)
                                        StatusTag(text: formatDistance(), isActive: true)
                                        if let fee = venue.entryFee {
                                            StatusTag(text: "\(fee)kr", isActive: true)
                                        }
                                    }
                                    
                                    HStack(spacing: 8) {
                                        StatusTag(text: venue.musicGenre, isActive: true)
                                        Spacer()  // Skyver åpen/stengt tag til høyre
                                        StatusTag(text: venue.isOpen ? "Åpen" : "Stengt", 
                                                isActive: venue.isOpen)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)  // Sikrer at containeren tar full bredde
                .background(Color.black.opacity(0.1))
            }
            .frame(width: 340, height: 550)
            .background(Color.clear)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Custom shape for å bare runde av topp-hjørnene
struct CustomCornerShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// Preview
struct VenueCard_Previews: PreviewProvider {
    static var previews: some View {
        VenueCard(venue: Venue(
            id: 1,
            name: "Test Venue",
            type: VenueType.bar,
            images: ["venue_placeholder"],
            isOpen: true,
            ageLimit: 20,
            entryFee: 100,
            hasCoatCheck: true,
            musicGenre: "Pop",
            crowdLevel: Venue.CrowdLevel.medium,
            description: "Test description",
            latitude: 59.9139,
            longitude: 10.7522
        ))
        .padding()
    }
}

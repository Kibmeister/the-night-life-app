import SwiftUI

struct VenueDetailView: View {
    let venue: Venue
    @State private var selectedImageIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Bildegalleri
                if !venue.images.isEmpty {
                    TabView {
                        ForEach(venue.images, id: \.self) { imageUrl in
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                        }
                    }
                    .frame(height: 300)
                    .tabViewStyle(.page)
                }
                
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
                images: ["venue_placeholder"],
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
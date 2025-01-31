import SwiftUI

struct VenueCard: View {
    let venue: Venue
    
    var body: some View {
        NavigationLink(destination: VenueDetailView(venue: venue)) {
            VStack(spacing: 0) {
                // Bakgrunnsbilde
                if let firstImage = venue.images.first {
                    AsyncImage(url: URL(string: firstImage)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 340)
                            .clipped()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
                
                // Informasjonscontainer
                VStack(alignment: .leading, spacing: 12) {
                    Text(venue.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.primary)
                    
                    // Tags container
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            // Venstre-alignede tags
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    StatusTag(text: venue.type.rawValue, isActive: true)
                                    StatusTag(text: "\(venue.ageLimit)+", isActive: true)
                                    if let fee = venue.entryFee {
                                        StatusTag(text: "\(fee)kr", isActive: true)
                                    }
                                }
                                
                                StatusTag(text: venue.musicGenre, isActive: true)
                            }
                            
                            Spacer()
                            
                            // Høyre-alignet åpningstidstag
                            StatusTag(text: venue.isOpen ? "Åpen" : "Stengt", 
                                    isActive: venue.isOpen)
                        }
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
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
            type: .bar,
            images: ["venue_placeholder"],
            isOpen: true,
            ageLimit: 20,
            entryFee: 100,
            hasCoatCheck: true,
            musicGenre: "Pop",
            crowdLevel: .medium,
            description: "Test description",
            latitude: 59.9139,
            longitude: 10.7522
        ))
        .padding()
    }
}

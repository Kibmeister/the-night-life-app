import SwiftUI

struct VenueFeedView: View {
    let venues: [Venue]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 20) {
                if venues.isEmpty {
                    Text("Ingen utesteder å vise")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(venues) { venue in
                        VenueCard(venue: venue)
                    }
                }
            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity)
    }
}

// Preview
struct VenueFeedView_Previews: PreviewProvider {
    static var previews: some View {
        VenueFeedView(venues: [
            Venue(id: 1,
                  name: "Test Venue",
                  type: .bar,
                  images: ["venue_placeholder"],
                  isOpen: true,
                  ageLimit: 20,
                  entryFee: 100,
                  hasCoatCheck: true,
                  musicGenre: "Pop",
                  crowdLevel: .medium,
                  description: "Test description")
        ])
    }
} 
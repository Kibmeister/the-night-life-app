import SwiftUI
import Inject

struct SearchResultRow: View {
    @ObserveInjection var inject
    let venue: Venue
    let onTap: () -> Void
    
    var body: some View {
        NavigationLink(destination: VenueDetailView(venue: venue)) {
            HStack {
                Text(venue.name)
                    .foregroundColor(.primary)
                Spacer()
                StatusTag(text: venue.isOpen ? "Åpen" : "Stengt", 
                         isActive: venue.isOpen)
            }
            .padding()
            .background(Color.white)
        }
        .enableInjection()
    }
} 
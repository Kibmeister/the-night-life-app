import SwiftUI

struct SearchResultRow: View {
    let venue: Venue
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
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
    }
} 
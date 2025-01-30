import SwiftUI

struct ContentView: View {
    @StateObject private var venueViewModel = VenueViewModel()
    @State private var selectedCategory: VenueType? = nil
    @State private var showingSearch = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Søkeknapp
            HStack {
                Button(action: {
                    showingSearch = true
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                .padding(.leading)
                
                Spacer()
            }
            .padding(.vertical, 8)
            
            CategoryTagsView(selectedCategory: $selectedCategory)
                .onChange(of: selectedCategory) { oldValue, newValue in
                    venueViewModel.filterVenues(by: newValue)
                }
                .padding(.horizontal, 8)
            
            VenueFeedView(venues: venueViewModel.filteredVenues)
        }
        .sheet(isPresented: $showingSearch) {
            SearchView()
        }
    }
}

// Preview
#Preview {
    ContentView()
} 
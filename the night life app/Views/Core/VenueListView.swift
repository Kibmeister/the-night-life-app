import SwiftUI

struct VenueListView: View {
    @StateObject private var viewModel = VenueViewModel()
    @State private var selectedCategory: VenueType?
    @State private var isMapView: Bool = false
    @State private var showingSearchModal = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    // Kategori-filter bar
                    CategoryTagsView(selectedCategory: $selectedCategory)
                        .padding(.vertical)
                        .background(Color.white)
                        .zIndex(99)
                    
                    // Hoved innhold (enten liste eller kart)
                    ZStack {
                        if !isMapView {
                            ScrollView {
                                LazyVStack(spacing: 20) {
                                    ForEach(viewModel.filteredVenues, id: \.id) { venue in
                                        VenueCard(venue: venue)
                                    }
                                }
                                .padding()
                                .padding(.bottom, 80)
                            }
                        } else {
                            VenueMapView(venues: viewModel.filteredVenues)
                        }
                    }
                }
                
                // Toggle-knapp
                VStack {
                    Spacer()
                    ViewToggleButton(isMapView: $isMapView)
                        .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: 
                Button(action: { showingSearchModal = true }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                }
            )
            .sheet(isPresented: $showingSearchModal) {
                SearchModalView(
                    isPresented: $showingSearchModal,
                    searchText: $searchText,
                    venues: viewModel.venues
                )
                .presentationDetents([.large])
            }
        }
        .onChange(of: selectedCategory) { oldValue, newValue in
            viewModel.filterVenues(by: newValue)
        }
    }
}

#Preview {
    VenueListView()
} 
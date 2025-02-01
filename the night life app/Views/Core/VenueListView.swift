import SwiftUI
import Inject

struct VenueListView: View {
    @ObserveInjection var inject
    @StateObject private var viewModel = VenueViewModel()
    @State private var selectedCategory: VenueType?
    @State private var isMapView: Bool = false
    @State private var showingSearchModal = false
    @State private var searchText = ""
    @State private var isPreviewActive: Bool = false
    @State private var scrollID: Int?
    @State private var isScrolling: Bool = false
    
    private var venueListContent: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.filteredVenues, id: \.id) { venue in
                    VenueCard(venue: venue)
                        .id(venue.id)
                        .onTapGesture {
                            withAnimation {
                                scrollID = 0
                            }
                        }
                }
            }
            .padding()
            .padding(.bottom, 80)
        }
        .scrollPosition(id: $scrollID)
        .onScrollPhaseChange { _, newPhase in
            withAnimation(.easeInOut(duration: 0.2)) {
                switch newPhase {
                case .idle:
                    isScrolling = false
                case .animating, .tracking, .decelerating, .interacting:
                    isScrolling = true
                @unknown default:
                    isScrolling = false
                }
            }
        }
        .contentMargins(.horizontal, 10, for: .scrollContent)
    }
    
    private var mainContent: some View {
        ZStack {
            if !isMapView {
                venueListContent
            } else {
                VenueMapView(venues: viewModel.filteredVenues, 
                           isMapView: $isMapView,
                           isPreviewActive: $isPreviewActive)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    mainContent
                }
                
                VStack(spacing: 8) {
                    if !isPreviewActive {
                        ViewToggleButton(isMapView: $isMapView, isPreviewActive: isPreviewActive)
                    }
                    MenuBar(isPreviewActive: $isPreviewActive)
                }
                .padding(.bottom, 30)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    CategoryTagsView(selectedCategory: $selectedCategory)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSearchModal = true }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }
                }
            }
            .toolbarVisibility(isScrolling ? .hidden : .visible)
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
        .enableInjection()
    }
}

#Preview {
    VenueListView()
} 

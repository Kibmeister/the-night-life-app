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
    @State private var lastScrollPosition: CGFloat = 0
    @State private var navBarOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    // Hoved innhold (enten liste eller kart)
                    ZStack {
                        if !isMapView {
                            ScrollView {
                                GeometryReader { geometry in
                                    Color.clear.preference(
                                        key: ScrollOffsetPreferenceKey.self,
                                        value: geometry.frame(in: .named("scroll")).minY
                                    )
                                }
                                .frame(height: 0)
                                
                                LazyVStack(spacing: 20) {
                                    ForEach(viewModel.filteredVenues, id: \.id) { venue in
                                        VenueCard(venue: venue)
                                    }
                                }
                                .padding()
                                .padding(.bottom, 80)
                            }
                            .coordinateSpace(name: "scroll")
                            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                                let delta = value - lastScrollPosition
                                print("=== SCROLL DEBUG ===")
                                print("Current scroll position: \(value)")
                                print("Last scroll position: \(lastScrollPosition)")
                                print("Delta: \(delta)")
                                print("Scroll direction: \(delta < 0 ? "DOWN ⬇️" : "UP ⬆️")")
                                print("------------------")
                                
                                if abs(delta) > 5 {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        // Scroll ned (swipe opp) -> skjul navbar
                                        if delta < 0 {
                                            print("Hiding navbar (moving up)")
                                            navBarOffset = -300 // Flytt navbar opp og ut av view
                                        }
                                        // Scroll opp (swipe ned) -> vis navbar
                                        else {
                                            print("Showing navbar (moving down)")
                                            navBarOffset = 0 // Flytt navbar tilbake til original posisjon
                                        }
                                    }
                                    lastScrollPosition = value
                                }
                            }
                        } else {
                            VenueMapView(venues: viewModel.filteredVenues, 
                                       isMapView: $isMapView,
                                       isPreviewActive: $isPreviewActive)
                        }
                    }
                }
                
                // Toggle-knapp
                if !isPreviewActive {
                    ViewToggleButton(isMapView: $isMapView, isPreviewActive: isPreviewActive)
                        .padding(.bottom, 30)
                }
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
        .offset(y: navBarOffset) // Animerer hele NavigationView
        .enableInjection()
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    VenueListView()
} 

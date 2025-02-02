import SwiftUI
import Inject

struct SearchView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) private var dismiss
    @StateObject private var searchViewModel = SearchViewModel()
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Søkefelt
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Søk etter utested...", text: $searchViewModel.searchText)
                        .focused($isSearchFieldFocused)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                    
                    if !searchViewModel.searchText.isEmpty {
                        Button(action: {
                            searchViewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding()
                
                Divider()
                    .padding(.horizontal)
                
                // Søkeresultater
                List(searchViewModel.filteredVenues) { venue in
                    NavigationLink(destination: VenueDetailView(venue: venue)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(venue.name)
                                .font(.headline)
                            Text(venue.type.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Avbryt") {
                dismiss()
            })
        }
        .onAppear {
            isSearchFieldFocused = true
        }
        .enableInjection()
    }
}

// Preview
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
} 
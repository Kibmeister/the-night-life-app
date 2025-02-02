import SwiftUI
import Inject

struct SearchModalView: View {
    @ObserveInjection var inject
    @Binding var isPresented: Bool
    @Binding var searchText: String
    let venues: [Venue]
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SearchViewModel()
    
    var filteredVenues: [Venue] {
        if searchText.isEmpty {
            return []
        }
        return venues.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Handle bar
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 10)
                
                // Søkefelt
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Søk etter utested...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding()
                
                // Resultatliste
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredVenues) { venue in
                            SearchResultRow(venue: venue) {
                                dismiss()
                                isPresented = false
                                
                                // Litt forsinkelse for å la modalen lukkes først
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    if let window = UIApplication.shared.windows.first {
                                        let rootView = NavigationView {
                                            VenueDetailView(venue: venue)
                                        }
                                        window.rootViewController = UIHostingController(rootView: rootView)
                                    }
                                }
                            }
                            Divider()
                        }
                    }
                }
                .background(Color.white)
            }
            .background(Color.white)
        }
        .enableInjection()
    }
}
import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published private(set) var filteredVenues: [Venue] = []
    private var venues: [Venue] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Hent venues fra VenueViewModel (for nå bruker vi dummy data)
        venues = VenueViewModel().venues
        
        // Sett opp søkefiltrering
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterVenues(searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterVenues(_ searchText: String) {
        // Tøm filteredVenues hvis søketeksten er tom
        guard !searchText.isEmpty else {
            filteredVenues = []
            return
        }
        
        // Filtrer venues bare når det finnes søketekst
        filteredVenues = venues.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.type.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }
} 
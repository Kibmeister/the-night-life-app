import SwiftUI
import MapKit
import Inject

struct VenueMapView: View {
    @ObserveInjection var inject
    let venues: [Venue]
    @Binding var isMapView: Bool
    @Binding var isPreviewActive: Bool
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.91127, longitude: 10.74611),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    @State private var showingUserLocation = false
    @State private var selectedVenue: Venue? {
        didSet {
            isPreviewActive = selectedVenue != nil
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region, 
                showsUserLocation: showingUserLocation,
                annotationItems: venues + (showingUserLocation ? [createUserLocationVenue()] : [])) { venue in
                MapAnnotation(coordinate: venue.coordinate) {
                    if venue.id == -1 {
                        VStack {
                            Image(systemName: "location.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("Din posisjon")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .fontWeight(.bold)
                        }
                    } else {
                        Button(action: {
                            print("Pin klikket for venue: \(venue.name)")
                            withAnimation {
                                selectedVenue = venue
                            }
                        }) {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                                Text(venue.name)
                                    .font(.caption)
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                            }
                        }
                        .onAppear {
                            print("Pin lagt til på kartet for: \(venue.name)")
                        }
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    selectedVenue = nil
                }
            }
            
            // My Location og zoom-knapper
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        // Zoom inn knapp
                        Button(action: {
                            withAnimation {
                                region.span = MKCoordinateSpan(
                                    latitudeDelta: region.span.latitudeDelta * 0.5,
                                    longitudeDelta: region.span.longitudeDelta * 0.5
                                )
                            }
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .padding(12)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        
                        // Zoom ut knapp
                        Button(action: {
                            withAnimation {
                                region.span = MKCoordinateSpan(
                                    latitudeDelta: region.span.latitudeDelta * 2.0,
                                    longitudeDelta: region.span.longitudeDelta * 2.0
                                )
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.title2)
                                .padding(12)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        
                        // Min posisjon knapp
                        Button(action: {
                            showingUserLocation.toggle()
                            if showingUserLocation {
                                if let location = locationManager.userLocation {
                                    withAnimation {
                                        region.center = location.coordinate
                                        region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                    }
                                }
                            }
                        }) {
                            Image(systemName: showingUserLocation ? "location.fill" : "location")
                                .font(.title2)
                                .padding(12)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                    }
                    .padding()
                }
                
                // Toggle-knapp som kun vises når ingen venue er valgt
                if selectedVenue == nil {
                    ViewToggleButton(isMapView: $isMapView, 
                                    isPreviewActive: selectedVenue != nil)
                        .padding(.bottom, 30)
                }
            }
            
            // Venue Preview
            if let venue = selectedVenue {
                VenueMapPreview(venue: venue)
                    .transition(.move(edge: .bottom))
            }
        }
        .enableInjection()
    }
    
    // Hjelpefunksjon for å lage en "venue" for brukerens lokasjon
    private func createUserLocationVenue() -> Venue {
        Venue(
            id: -1,  // Bruker negativ ID for å skille fra faktiske venues
            name: "Din posisjon",
            type: .bar,
            image: "venue_placeholder",
            isOpen: true,
            ageLimit: 0,
            entryFee: nil,
            hasCoatCheck: false,
            musicGenre: "",
            crowdLevel: .low,
            description: "",
            latitude: locationManager.userLocation?.coordinate.latitude ?? 59.91127,
            longitude: locationManager.userLocation?.coordinate.longitude ?? 10.74611
        )
    }
}

#Preview {
    VenueMapView(venues: [
        Venue(
            id: 1,
            name: "Test Venue",
            type: .bar,
            image: "venue_placeholder",
            isOpen: true,
            ageLimit: 20,
            entryFee: 100,
            hasCoatCheck: true,
            musicGenre: "Pop/Rock",
            crowdLevel: .medium,
            description: "Et koselig sted i hjertet av byen.",
            latitude: 59.9139,
            longitude: 10.7522
        )
    ], isMapView: .constant(true), isPreviewActive: .constant(false))
} 
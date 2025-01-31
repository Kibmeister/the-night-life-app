import SwiftUI
import MapKit

struct VenueMapView: View {
    let venues: [Venue]
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.9139, longitude: 10.7522), // Oslo sentrum
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    VenueMapView(venues: [])
} 
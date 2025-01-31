import MapKit

struct Venue: Identifiable {
    let id: Int
    let name: String
    let type: VenueType
    var images: [String]
    var isOpen: Bool
    let ageLimit: Int
    let entryFee: Int?
    let hasCoatCheck: Bool
    let musicGenre: String
    var crowdLevel: CrowdLevel
    let description: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum CrowdLevel: String {
        case low = "Få gjester"
        case medium = "Middels fullt"
        case high = "Mange gjester"
    }
} 
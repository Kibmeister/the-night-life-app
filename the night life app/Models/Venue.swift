import MapKit

struct Venue: Identifiable, Codable {
    let id: Int
    let name: String
    let type: VenueType
    let image: String
    var isOpen: Bool
    let ageLimit: Int
    let entryFee: Int?
    let hasCoatCheck: Bool
    let musicGenre: String
    var crowdLevel: CrowdLevel
    let description: String
    let latitude: Double?
    let longitude: Double?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
    }
    
    enum CrowdLevel: String, Codable {
        case low = "Få gjester"
        case medium = "Middels fullt"
        case high = "Mange gjester"
    }
} 
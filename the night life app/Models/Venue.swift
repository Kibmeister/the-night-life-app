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
    
    enum CrowdLevel: String {
        case low = "Få gjester"
        case medium = "Middels fullt"
        case high = "Mange gjester"
    }
} 
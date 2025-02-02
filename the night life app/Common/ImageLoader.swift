import SwiftUI
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    func load(from imageName: String) {
        print("DEBUG ImageLoader: Prøver å laste bilde fra: \(imageName)")
        
        // Konstruer korrekt sti: ImageAssets/[venue_name]/[venue_name]
        let fullPath = "ImageAssets/\(imageName)/\(imageName)"
        
        if let image = UIImage(named: fullPath) {
            print("DEBUG ImageLoader: Bilde lastet vellykket: \(fullPath)")
            self.image = image
        } else {
            print("DEBUG ImageLoader Error: Kunne ikke finne bilde: \(fullPath)")
            print("DEBUG ImageLoader Tips: Sjekk at bildet eksisterer i Assets.xcassets/\(fullPath)")
        }
    }
    
    func cancel() {
        // Ikke nødvendig for lokale bilder, men beholder metoden for API-kompatibilitet
    }
} 
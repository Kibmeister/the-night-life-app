import SwiftUI
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    func load(from imageName: String) {
        print("DEBUG ImageLoader: Prøver å laste bilde fra: \(imageName)")
        
        if let image = UIImage(named: imageName) {
            print("DEBUG ImageLoader: Bilde lastet vellykket: \(imageName)")
            self.image = image
        } else {
            print("DEBUG ImageLoader Error: Kunne ikke finne bilde: \(imageName)")
            print("DEBUG ImageLoader Tips: Sjekk at bildet eksisterer i Assets.xcassets/\(imageName)")
        }
    }
    
    func cancel() {
        // Ikke nødvendig for lokale bilder, men beholder metoden for API-kompatibilitet
    }
} 
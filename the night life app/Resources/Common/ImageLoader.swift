import SwiftUI
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    func load(from imageName: String) {
        print("DEBUG ImageLoader: Prøver å laste bilde fra: \(imageName)")
        
        // Konstruer korrekt sti: ImageAssets/[venue_name]/[venue_name]
        let fullPath = "ImageAssets/\(imageName)/\(imageName)"
        
        // List opp tilgjengelige assets for debugging
        let assetNames = Bundle.main.paths(forResourcesOfType: "png", inDirectory: "Assets.xcassets")
        print("DEBUG ImageLoader: Tilgjengelige assets: \(assetNames)")
        
        if let image = UIImage(named: fullPath) {
            print("DEBUG ImageLoader: Bilde lastet vellykket: \(fullPath)")
            self.image = image
        } else {
            // Prøv å laste direkte fra assets katalogen
            if let directImage = UIImage(named: imageName) {
                print("DEBUG ImageLoader: Bilde lastet direkte: \(imageName)")
                self.image = directImage
            } else {
                print("DEBUG ImageLoader Error: Kunne ikke finne bilde: \(fullPath)")
                print("DEBUG ImageLoader Tips: Sjekk at bildet eksisterer i Assets.xcassets/\(fullPath)")
                print("DEBUG ImageLoader Tips: Prøvde også direkte tilgang: \(imageName)")
            }
        }
    }
    
    func cancel() {
        // Ikke nødvendig for lokale bilder, men beholder metoden for API-kompatibilitet
    }
} 
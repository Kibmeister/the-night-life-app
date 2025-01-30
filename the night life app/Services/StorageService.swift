import FirebaseStorage
import UIKit

class StorageService {
    static let shared = StorageService()
    private let storage = Storage.storage().reference()
    
    // Last opp bilde og få tilbake URL
    func uploadImage(_ image: UIImage, venueName: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.6) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kunne ikke konvertere bilde til data"])
        }
        
        // Lag en sikker filsti for bildet
        let safeVenueName = venueName
            .lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "å", with: "a")
            .replacingOccurrences(of: "æ", with: "ae")
            .replacingOccurrences(of: "ø", with: "o")
        
        let imagePath = "venues/\(safeVenueName)_image.jpg"
        print("Prøver å laste opp til: \(imagePath)")
        
        let imageRef = storage.child(imagePath)
        
        do {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            print("Starter opplasting for \(venueName)...")
            _ = try await imageRef.putDataAsync(imageData, metadata: metadata)
            print("Opplasting fullført for \(venueName), henter URL...")
            let url = try await imageRef.downloadURL()
            print("Vellykket opplasting for \(venueName): \(url.absoluteString)")
            return url.absoluteString
        } catch {
            print("Feil ved opplasting for \(venueName): \(error.localizedDescription)")
            throw error
        }
    }
    
    // Last ned bilde fra URL
    func downloadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ugyldig URL"])
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kunne ikke lage bilde fra data"])
        }
        
        return image
    }
} 

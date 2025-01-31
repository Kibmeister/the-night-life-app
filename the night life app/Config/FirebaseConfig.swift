import FirebaseCore
import FirebaseStorage

class FirebaseConfig {
    static func configure() {
        print("DEBUG Firebase: Starter Firebase-konfigurasjon")
        
        // Sjekk om config-filen eksisterer
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
            print("DEBUG Firebase: Config-fil funnet på: \(path)")
        } else {
            print("DEBUG Firebase Error: GoogleService-Info.plist ikke funnet!")
            return
        }
        
        FirebaseApp.configure()
        print("DEBUG Firebase: FirebaseApp konfigurert")
        
        let storage = Storage.storage()
        print("DEBUG Firebase: Storage initialisert: \(storage)")
    }
}

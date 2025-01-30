//
//  the_night_life_appApp.swift
//  the night life app
//
//  Created by Kasper Borgbjerg on 30/01/2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Debug print for å sjekke om config-filen er funnet
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
            print("Firebase config file found at: \(path)")
        } else {
            print("ERROR: GoogleService-Info.plist not found!")
        }
        
        return true
    }
}

@main
struct the_night_life_appApp: App {
    // Registrer app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}

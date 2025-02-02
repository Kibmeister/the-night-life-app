//
//  the_night_life_appApp.swift
//  the night life app
//
//  Created by Kasper Borgbjerg on 30/01/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage
@_exported import Inject

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseConfig.configure()  // Bruker vår egen konfigurasjonsfil
        return true
    }
}

@main
struct the_night_life_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .enableInjection()
        }
    }
}

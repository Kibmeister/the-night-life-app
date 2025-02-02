import Foundation

// Hovedmodell for bruker
struct ProfileUser {
    let username: String
    let avatar: String
    let settings: ProfileUserSettings
    
    // Standard initialisering
    init(username: String, avatar: String, settings: ProfileUserSettings) {
        self.username = username
        self.avatar = avatar
        self.settings = settings
    }
    
    // Hjelpefunksjon for å lage en dummy bruker
    static func dummyUser() -> ProfileUser {
        ProfileUser(
            username: "NightlifeUser",
            avatar: "person.circle.fill",
            settings: ProfileUserSettings(
                notifications: true,
                darkMode: true,
                language: "Norsk"
            )
        )
    }
}

// Innstillinger for bruker
struct ProfileUserSettings {
    let notifications: Bool
    let darkMode: Bool
    let language: String
    
    init(notifications: Bool, darkMode: Bool, language: String) {
        self.notifications = notifications
        self.darkMode = darkMode
        self.language = language
    }
} 
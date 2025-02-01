import SwiftUI

struct ProfileModule: View {
    @Environment(\.dismiss) var dismiss
    
    // Dummy data
    private let user = ProfileUser.dummyUser()
    
    var body: some View {
        NavigationView {
            List {
                // Avatar og brukernavn
                HStack {
                    Image(systemName: user.avatar)
                        .font(.system(size: 60))
                    VStack(alignment: .leading) {
                        Text(user.username)
                            .font(.title2)
                            .bold()
                        Text("Aktiv bruker")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical)
                
                // Konto-innstillinger
                Section("Konto-innstillinger") {
                    Toggle("Varsler", isOn: .constant(user.settings.notifications))
                    Toggle("Mørk modus", isOn: .constant(user.settings.darkMode))
                    HStack {
                        Text("Språk")
                        Spacer()
                        Text(user.settings.language)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lukk") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileModule()
} 
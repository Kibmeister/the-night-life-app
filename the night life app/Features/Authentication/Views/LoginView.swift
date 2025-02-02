import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Spacer()
                Button("Avbryt") {
                    dismiss()
                }
                .foregroundColor(.black)
                .padding()
            }
            
            // Logo
            AuthHeaderText()
                .padding(.top, 40)
            
            Spacer()
            
            // Auth buttons
            VStack(spacing: 16) {
                AuthButton(
                    title: "Fortsett med Apple",
                    icon: Image(systemName: "apple.logo"),
                    style: .apple
                ) {
                    // Apple login handling
                }
                
                AuthButton(
                    title: "Fortsett med Google",
                    icon: Image("google_icon"), // Trenger å legge til dette i assets
                    style: .google
                ) {
                    // Google login handling
                }
                
                AuthButton(
                    title: "Fortsett med email",
                    style: .primary
                ) {
                    // Email login handling
                }
                
                AuthButton(
                    title: "Fortsett med SSO",
                    style: .primary
                ) {
                    // SSO login handling
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Footer links
            HStack(spacing: 24) {
                Button("Personvernerklæring") {
                    // Handle privacy policy
                }
                
                Button("Vilkår og betingelser") {
                    // Handle terms
                }
            }
            .font(.system(size: 14))
            .foregroundColor(.gray)
            .padding(.bottom, 24)
        }
        .background(Color.white)
    }
} 
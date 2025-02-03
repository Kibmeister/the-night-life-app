import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var shouldShowVenueList = false
    
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
                    style: .primary
                ) {
                    // Apple login handling
                }
                .frame(width: 300)
                
                AuthButton(
                    title: "Fortsett med Google",
                    icon: Image("google_icon"),
                    style: .primary
                ) {
                    shouldShowVenueList = true
                }
                .frame(width: 300)
                
                AuthButton(
                    title: "Fortsett med email",
                    style: .primary
                ) {
                    // Email login handling
                }
                .frame(width: 300)
                
                AuthButton(
                    title: "Fortsett med SSO",
                    style: .primary
                ) {
                    // SSO login handling
                }
                .frame(width: 300)
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
            .padding(.bottom, 50)
        }
        .background(Color.white)
        .fullScreenCover(isPresented: $shouldShowVenueList) {
            VenueListView()
        }
    }
} 
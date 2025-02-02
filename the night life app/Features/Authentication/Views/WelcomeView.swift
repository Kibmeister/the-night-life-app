import SwiftUI
import Inject

struct WelcomeView: View {
    @State private var shouldShowLogin = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 100) {
                AuthHeaderText()
                
                AuthButton(
                    title: "Velkommen",
                    style: .primary
                ) {
                    shouldShowLogin = true
                }
                .frame(width: 400)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .fullScreenCover(isPresented: $shouldShowLogin) {
                LoginView()
            }
        }
        .enableInjection()
    }
} 

#Preview {
    WelcomeView()
}
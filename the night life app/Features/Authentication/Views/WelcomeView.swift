import SwiftUI
import Inject

struct WelcomeView: View {
    @State private var shouldShowLogin = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack {
                    AuthHeaderText()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                AuthButton(
                    title: "Velkommen",
                    style: .primary
                ) {
                    shouldShowLogin = true
                }
                .frame(width: 300)
                .padding(.bottom, 50)
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
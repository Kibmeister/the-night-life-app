import SwiftUI
import Inject

struct MenuBar: View {
    @ObserveInjection var inject
    @State private var showProfileModule = false
    @State private var showMoodModule = false
    
    var body: some View {
        HStack(spacing: 20) {
            // Profil-ikon
            Button(action: {
                withAnimation {
                    showProfileModule.toggle()
                }
            }) {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            // Horisontal strek
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.white)
            
            // Danser-ikon
            Button(action: {
                withAnimation {
                    showMoodModule.toggle()
                }
            }) {
                Image(systemName: "figure.dance")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color.black)
        .cornerRadius(25)
        .frame(width: UIScreen.main.bounds.width * 0.5) // Dobbelt så bred som ViewToggleButton
        .shadow(radius: 5)
        .zIndex(100)
        .sheet(isPresented: $showProfileModule) {
            ProfileModule()
        }
        .sheet(isPresented: $showMoodModule) {
            MoodModule()
        }
        .enableInjection()
    }
}

#Preview {
    MenuBar()
} 
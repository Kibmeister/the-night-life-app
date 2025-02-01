import SwiftUI
import Inject

struct ViewToggleButton: View {
    @ObserveInjection var inject
    @Binding var isMapView: Bool
    let isPreviewActive: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                isMapView.toggle()
            }
        }) {
            Image(systemName: isMapView ? "list.bullet" : "map")
                .font(.title3)
                .foregroundColor(.white)
                .padding(.top, 6)
                .padding(.bottom, 6)
                .padding(.leading, 12)
                .padding(.trailing, 12)
                .background(Color.gray)
                .cornerRadius(20)
                .clipShape(Rectangle())
                
        }
        .opacity(isPreviewActive ? 0 : 1)
        .animation(.easeInOut, value: isPreviewActive)
        .enableInjection()
    }
}

#Preview {
    ViewToggleButton(isMapView: .constant(false), isPreviewActive: false)
}
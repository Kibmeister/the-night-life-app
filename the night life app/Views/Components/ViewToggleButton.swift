import SwiftUI

struct ViewToggleButton: View {
    @Binding var isMapView: Bool
    let isPreviewActive: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                isMapView.toggle()
            }
        }) {
            Image(systemName: isMapView ? "list.bullet" : "map")
                .font(.title2)
                .foregroundColor(.white)
                .padding(12)
                .background(Color.black)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .opacity(isPreviewActive ? 0 : 1)
        .animation(.easeInOut, value: isPreviewActive)
    }
}

#Preview {
    ViewToggleButton(isMapView: .constant(false), isPreviewActive: false)
}
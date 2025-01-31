import SwiftUI

struct ViewToggleButton: View {
    @Binding var isMapView: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                isMapView.toggle()
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: isMapView ? "list.bullet" : "map")
                    .font(.system(size: 16))
                Text(isMapView ? "Liste" : "Kart")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.black)
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
        }
    }
}

#Preview {
    ViewToggleButton(isMapView: .constant(false))
}
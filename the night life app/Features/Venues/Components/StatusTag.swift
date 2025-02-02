import SwiftUI
import Inject

struct StatusTag: View {
    @ObserveInjection var inject
    let text: String
    let isActive: Bool
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .lineLimit(1)  // Forhindrer text wrapping
            .fixedSize(horizontal: true, vertical: false)  // Lar taggen ekspandere i bredden
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(isActive ? Color.black : Color.gray.opacity(0.2))
            .foregroundColor(isActive ? .white : .black)
            .cornerRadius(8)
            .enableInjection()
    }
}

// Preview
struct StatusTag_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            StatusTag(text: "Åpen", isActive: true)
            StatusTag(text: "Stengt", isActive: false)
        }
        .padding()
    }
} 
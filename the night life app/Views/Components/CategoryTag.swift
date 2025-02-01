import SwiftUI
import Inject

struct CategoryTag: View {
    @ObserveInjection var inject
    let text: String
    let isSelected: Bool
    
    var body: some View {
        Text(text)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.clear)
            .foregroundColor(.black)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.black : Color.gray.opacity(0.2), lineWidth: 1)
            )
            .enableInjection()
    }
}

// Preview provider for utvikling
struct CategoryTag_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CategoryTag(text: "Bar", isSelected: true)
            CategoryTag(text: "Pub", isSelected: false)
        }
        .padding()
    }
} 
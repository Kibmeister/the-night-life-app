import SwiftUI

struct CategoryTag: View {
    let type: VenueType
    let isSelected: Bool
    
    var body: some View {
        Text(type.rawValue)
            .font(.subheadline)
            .fontWeight(.medium)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
    }
}

// Preview provider for utvikling
struct CategoryTag_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CategoryTag(type: .bar, isSelected: true)
            CategoryTag(type: .pub, isSelected: false)
        }
        .padding()
    }
} 
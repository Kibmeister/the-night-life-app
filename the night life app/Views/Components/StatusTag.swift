import SwiftUI

struct StatusTag: View {
    let text: String
    let isActive: Bool
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.black.opacity(0.2))
            .foregroundColor(.black)
            .cornerRadius(15)
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
import SwiftUI

struct AuthButton: View {
    let title: String
    let icon: Image?
    let action: () -> Void
    let style: ButtonStyle
    
    enum ButtonStyle {
        case primary    // Hvit bakgrunn, svart border
        case apple     // Apple-stil
        case google    // Google-stil
        case plain     // Bare tekst
    }
    
    init(
        title: String,
        icon: Image? = nil,
        style: ButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                icon?
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(style == .primary ? Color.white : Color.clear)
            .foregroundColor(style == .primary ? .black : .black)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: style == .primary ? 1 : 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
} 
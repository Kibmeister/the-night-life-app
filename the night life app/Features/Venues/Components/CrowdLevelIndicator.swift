import SwiftUI
import Inject

struct CrowdLevelIndicator: View {
    @ObserveInjection var inject
    let level: Venue.CrowdLevel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hvor fullt er det?")
                .font(.headline)
            
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Rectangle()
                        .frame(height: 8)
                        .foregroundColor(getColor(for: index))
                }
            }
            
            Text(level.rawValue)
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
        .enableInjection()
    }
    
    private func getColor(for index: Int) -> Color {
        let activeColor: Color = {
            switch level {
            case .low: return .green
            case .medium: return .yellow
            case .high: return .red
            }
        }()
        
        let isActive: Bool = {
            switch level {
            case .low: return index == 0
            case .medium: return index <= 1
            case .high: return true
            }
        }()
        
        return isActive ? activeColor : Color.gray.opacity(0.3)
    }
}

// Preview
struct CrowdLevelIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CrowdLevelIndicator(level: .low)
            CrowdLevelIndicator(level: .medium)
            CrowdLevelIndicator(level: .high)
        }
        .padding()
    }
} 
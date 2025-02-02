import SwiftUI

struct MoodModule: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Humør-innhold kommer snart!")
                    .font(.title2)
            }
            .navigationTitle("Humør")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lukk") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MoodModule()
} 
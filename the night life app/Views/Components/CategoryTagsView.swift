import SwiftUI

struct CategoryTagsView: View {
    @Binding var selectedCategory: VenueType?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(VenueType.allCases, id: \.self) { type in
                    CategoryTag(type: type, isSelected: selectedCategory == type)
                        .onTapGesture {
                            withAnimation {
                                if selectedCategory == type {
                                    selectedCategory = nil  // Fjern filteret hvis samme kategori velges igjen
                                } else {
                                    selectedCategory = type // Velg ny kategori
                                }
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

// Preview
struct CategoryTagsView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTagsView(selectedCategory: .constant(nil))
    }
} 
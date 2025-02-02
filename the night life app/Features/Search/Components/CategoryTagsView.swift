import SwiftUI
import Inject

struct CategoryTagsView: View {
    @ObserveInjection var inject
    @Binding var selectedCategory: VenueType?
    
    // Flytter tap-logikken til en egen funksjon
    private func handleCategoryTap(_ type: VenueType) {
        withAnimation {
            selectedCategory = (selectedCategory == type) ? nil : type
        }
    }
    
    // Lager en egen view for kategorilisten
    private var categoryList: some View {
        HStack(spacing: 12) {
            ForEach(VenueType.allCases, id: \.self) { type in
                CategoryTag(text: type.rawValue, isSelected: selectedCategory == type)
                    .onTapGesture {
                        handleCategoryTap(type)
                    }
            }
        }
        .padding(.horizontal)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            categoryList
        }
        .enableInjection()
    }
}

// Preview
struct CategoryTagsView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTagsView(selectedCategory: .constant(nil))
    }
} 
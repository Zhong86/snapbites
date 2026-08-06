import SwiftUI
import SwiftData

struct SummaryView: View {
    @Query var ingredients: [Ingredient]
    @State private var showAddSummary = false
    
    var body: some View {
        SummaryListView(ingredients: ingredients)
    }
}


#Preview {
    SummaryView()
}

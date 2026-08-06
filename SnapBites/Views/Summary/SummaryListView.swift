import SwiftUI

struct SummaryListView: View {
    let ingredients: [Ingredient]
    @State private var selectedIngredient: Ingredient?

    var body: some View {
        NavigationStack {
            List(ingredients) { ingredient in
                Button {
                    selectedIngredient = ingredient
                } label: {
                    SummarySingle(ingredient: ingredient)
                }
                .buttonStyle(.plain)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .sheet(item: $selectedIngredient) { ingredient in
                SummaryChecklistView(ingredient: ingredient)
            }
        }
    }
}

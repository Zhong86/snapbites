import SwiftUI

struct IngredientListEditor: View {
    @Binding var ingredientNames: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients")
                .font(.system(size: 14, weight: .bold))

            ForEach(ingredientNames.indices, id: \.self) { index in
                HStack(spacing: 8) {
                    TextField("Ingredient name", text: $ingredientNames[index])
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )

                    // Only show remove once there's more than one row
                    if ingredientNames.count > 1 {
                        Button {
                            ingredientNames.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }

            Button {
                ingredientNames.append("")
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add ingredient")
                }
                .foregroundColor(.green)
            }
        }
    }
}

#Preview {
    IngredientListEditor(ingredientNames: .constant(["Udang", ""]))
        .padding()
}

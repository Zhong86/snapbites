import SwiftUI

struct IngredientListEditor: View {
    @Binding var ingredientNames: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Ingredients")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.secondaryTextColor)

            ForEach(ingredientNames.indices, id: \.self) { index in
                HStack(spacing: 8) {
                    TextField("Ingredient name", text: $ingredientNames[index])
                        .font(.system(size: 15))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(Color.appBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.cardStroke, lineWidth: 1)
                        )

                    // Only show remove once there's more than one row
                    if ingredientNames.count > 1 {
                        Button {
                            ingredientNames.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(Color.accentRed)
                        }
                    }
                }
            }

            Button {
                ingredientNames.append("")
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add ingredient")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.primaryGreen)
            }
        }
    }
}

#Preview {
    IngredientListEditor(ingredientNames: .constant(["Udang", ""]))
        .padding()
        .background(Color.appBackground)
}

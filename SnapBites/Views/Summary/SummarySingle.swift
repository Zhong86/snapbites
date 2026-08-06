import SwiftUI
import SwiftData

struct SummarySingle: View {
    @Bindable var ingredient: Ingredient

    var body: some View {
        HStack(spacing: 12) {
            Image(ingredient.possibleCauses.first?.symptom?.imageName ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .padding(10)
                .background(Color.appBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text(ingredient.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)
                    .lineLimit(1)

                let activeCauses = ingredient.possibleCauses.filter {
                    $0.status != "non_cause"
                }

                HStack(spacing: 6) {
                    if activeCauses.isEmpty && !ingredient.possibleCauses.isEmpty {
                        SafePill()
                    } else {
                        ForEach(activeCauses, id: \.persistentModelID) { cause in
                            if let symptom = cause.symptom {
                                Pill(
                                    text: symptom.name,
                                    borderColor: cause.status == "cause" ? Color.accentRed : Color.primaryGreen
                                )
                            }
                        }
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(ingredient.timeUpdated.formatted(.dateTime.month(.abbreviated).day()))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.primaryGreen)
                Text(ingredient.timeUpdated.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 12))
                    .foregroundStyle(Color.secondaryTextColor)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.secondaryTextColor)
                    .padding(.top, 2)
            }
        }
        .summaryCard()
    }
}

#Preview {
}

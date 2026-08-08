import SwiftUI

struct SummaryListView: View {
    let ingredients: [Ingredient]
    @State private var selectedIngredient: Ingredient?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                if ingredients.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(ingredients) { ingredient in
                                Button {
                                    selectedIngredient = ingredient
                                } label: {
                                    SummarySingle(ingredient: ingredient)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top) {
                summaryToolbar
            }
            .sheet(item: $selectedIngredient) { ingredient in
                SummaryChecklistView(ingredient: ingredient)
            }
        }
    }

    // MARK: - Custom toolbar

    private var summaryToolbar: some View {
        HStack {
            Text("Summary")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.black)

            Spacer()

            HStack(spacing: 10) {
                Button {
                    // Calendar action
                } label: {
                    Image(systemName: "calendar")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.black)
                        .toolbarCircle()
                }

                Button {
                    // Filter action
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color.filterAccent)
                        .toolbarCircle()
                }

                Button {
                    // Settings action
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.black)
                        .toolbarCircle()
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.appBackground)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 64))
                .foregroundStyle(Color.primaryGreen)

            Text("No Summary Yet")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.black)

            Text("Start logging meals and symptoms to generate your first summary.")
                .font(.system(size: 15))
                .foregroundStyle(Color.secondaryTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                // Create first log action
            } label: {
                Text("Create First Log")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primaryGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .padding(.horizontal, 32)
            .padding(.top, 8)

            Spacer()
            Spacer()
        }
    }
}

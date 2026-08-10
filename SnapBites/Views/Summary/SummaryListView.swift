//
//  SummaryListView.swift
//  SnapBites
//
//  Created by Mac on 08/08/26.
//

import SwiftUI

struct SummaryListView: View {
    let ingredients: [Ingredient]
    @State private var selectedIngredient: Ingredient?

    // Drives the real filtering below via IngredientStatusFilterService.
    @State private var selectedStatusFilter: IngredientStatusFilter = .all
    @State private var isStatusFilterVisible = false

    private var filteredIngredients: [Ingredient] {
        IngredientStatusFilterService.filter(ingredients, by: selectedStatusFilter)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                if ingredients.isEmpty {
                    emptyState
                } else if filteredIngredients.isEmpty {
                    noFilterResultsState
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(filteredIngredients) { ingredient in
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
                VStack(spacing: 0) {
                    summaryToolbar

                    if isStatusFilterVisible {
                        ScrollView(.horizontal, showsIndicators: false) {
                            IngredientStatusFilterBar(selectedFilter: $selectedStatusFilter)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                        }
                        .background(Color.appBackground)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
            }
            .sheet(item: $selectedIngredient) { ingredient in
                SummaryChecklistView(ingredient: ingredient)
            }
        }
    }

    // MARK: - Custom toolbar

    private var summaryToolbar: some View {
        HStack {
            Text("Overview")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.black)

            Spacer()

            HStack(spacing: 10) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isStatusFilterVisible.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color.filterAccent)
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

    // MARK: - No filter results state

    private var noFilterResultsState: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.system(size: 64))
                .foregroundStyle(Color.primaryGreen)

            Text("No Matches")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.black)

            Text("No ingredients match the \"\(selectedStatusFilter.label)\" filter.")
                .font(.system(size: 15))
                .foregroundStyle(Color.secondaryTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedStatusFilter = .all
                }
            } label: {
                Text("Clear Filter")
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

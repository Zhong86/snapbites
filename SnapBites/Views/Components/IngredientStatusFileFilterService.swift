//
//  IngredientStatusFileFilterService.swift
//  SnapBites
//
//  Created by Mac on 08/08/26.
//

import Foundation

struct IngredientStatusFilterService {
    static func overallStatus(for ingredient: Ingredient) -> IngredientStatusFilter? {
        guard !ingredient.possibleCauses.isEmpty else { return nil }

        if ingredient.possibleCauses.contains(where: { $0.status == "cause" }) {
            return .unsafe
        }
        if ingredient.possibleCauses.contains(where: { $0.status == "unchecked" }) {
            return .unchecked
        }
        return .safe
    }
    
    static func filter(_ ingredients: [Ingredient], by filter: IngredientStatusFilter) -> [Ingredient] {
        guard filter != .all else { return ingredients }
        return ingredients.filter { overallStatus(for: $0) == filter }
    }
}


































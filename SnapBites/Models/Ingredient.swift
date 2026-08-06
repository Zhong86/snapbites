//
//  Ingredient.swift
//  SnapBites
//
//  Created by Mac on 04/08/26.
//
import Foundation
import SwiftData

@Model
final class Ingredient {
    var name: String
    var hasChecked: Bool
    var timeUpdated: Date
    
    @Relationship(deleteRule: .cascade, inverse: \PossibleCauses.ingredient)
        var possibleCauses: [PossibleCauses] = []

    init(
        name: String,
        hasChecked: Bool = false,
        timeUpdated: Date = Date()
    ) {
        self.name = name
        self.hasChecked = hasChecked
        self.timeUpdated = timeUpdated
    }
    
    public 
}

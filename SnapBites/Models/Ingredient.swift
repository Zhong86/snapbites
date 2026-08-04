//
//  Ingredient.swift
//  SnapBites
//
//  Created by Mac on 04/08/26.
//
import Foundation

struct Ingredient: Identifiable {
    let id: String
    var name: String
    var hasChecked: Bool
    var timeUpdated: Date

    init(
        id: String,
        name: String,
        hasChecked: Bool = false,
        timeUpdated: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.hasChecked = hasChecked
        self.timeUpdated = timeUpdated
    }
}

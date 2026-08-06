//
//  PossibleCauses.swift
//  SnapBites
//
//  Created by Mac on 04/08/26.
//
import Foundation
import SwiftData

@Model
final class PossibleCauses: Identifiable {
    var ingredient: Ingredient?
    var symptom: Symtomp?
    var status: String // unchecked | cause | non_cause
    var lastUpdated: Date

    init(
        ingredient: Ingredient,
        symptom: Symtomp,
        status: String = "unchecked",
        lastUpdated: Date = Date()
    ) {
        self.ingredient = ingredient
        self.symptom = symptom
        self.status = status
        self.lastUpdated = lastUpdated
    }
}

//
//  PossibleCauses.swift
//  SnapBites
//
//  Created by Mac on 04/08/26.
//
import Foundation

struct PossibleCauses: Identifiable {
    let id: String
    var ingredientId: String
    var symptompId: String
    var status: String // unchecked | cause | non_cause
    var lastUpdated: Date

    init(
        id: String,
        ingredientId: String,
        symptompId: String,
        status: String = "unchecked",
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.ingredientId = ingredientId
        self.symptompId = symptompId
        self.status = status
        self.lastUpdated = lastUpdated
    }
}

//
//  PossibleCauses.swift
//  SnapBites
//
//  Created by Mac on 04/08/26.
//
import Foundation

struct PossibleCauses: Hashable {
    let id: String
    var ingredientId: String
    var symtompId: String
    var status: String // unchecked | cause | non_cause
    var lastUpdated: Date

    init(
        id: String,
        ingredientId: String,
        symtompId: String,
        status: String = "unchecked",
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.ingredientId = ingredientId
        self.symtompId = symtompId
        self.status = status
        self.lastUpdated = lastUpdated
    }
}

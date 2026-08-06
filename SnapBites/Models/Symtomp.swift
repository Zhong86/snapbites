//
//  Symtomp.swift
//  SnapBites
//
//  Created by Mac on 04/08/26.
//

import Foundation
import SwiftData

@Model
final class Symtomp: Identifiable {
    var name: String
    var imageName: String
    var lastChecked: Date
    
    @Relationship(deleteRule: .cascade, inverse: \PossibleCauses.symptom)
        var possibleCauses: [PossibleCauses] = []

    init(
        name: String,
        imageName: String,
        lastChecked: Date = Date()
    ) {
        self.name = name
        self.imageName = imageName
        self.lastChecked = lastChecked
    }
}

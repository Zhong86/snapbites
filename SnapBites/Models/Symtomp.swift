//
//  Symtomp.swift
//  SnapBites
//
//  Created by Mac on 04/08/26.
//

import Foundation
import SwiftData

@Model
final class Symtomp {
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

var symptoms: [Symtomp] = [
    Symtomp(name: "kulit gatel",imageName: "kulit gatel",lastChecked: Date.now),
    Symtomp(name:"demam" ,imageName: "demam",lastChecked:Date.now),
    Symtomp(name: "bersin", imageName: "bersin",lastChecked:Date.now),
    Symtomp(name:"batuk", imageName: "batuk", lastChecked:Date.now),
    Symtomp(name: "hidung berair", imageName: "runny nose",lastChecked:Date.now),
    Symtomp(name:"muncul biduran", imageName: "biduran", lastChecked:Date.now),
    Symtomp(name: "mata merah", imageName: "mata merah", lastChecked: Date.now),
    Symtomp(name:"mual", imageName:"mual",lastChecked:Date.now),
    Symtomp(name: "muntah", imageName: "muntah", lastChecked: Date.now),
    Symtomp(name:"kram perut", imageName: "kram perut", lastChecked: Date.now),
    Symtomp(name: "diare", imageName: "diare", lastChecked: Date.now),
    Symtomp(name:"sakit perut", imageName: "sakit perut", lastChecked: Date.now),
    Symtomp(name: "sesak nafas", imageName: "sesak nafas", lastChecked: Date.now),
    Symtomp(name:"bengkak",imageName:"bengkak", lastChecked: Date.now),
]

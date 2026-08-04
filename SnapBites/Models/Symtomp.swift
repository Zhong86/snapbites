//
//  Symtomp.swift
//  SnapBites
//
//  Created by Mac on 04/08/26.
//

import Foundation

struct Symtomp: Identifiable {
    let id: String
    var name: String
    var imageName: String
    var lastChecked: Date

    init(
        id: String,
        name: String,
        imageName: String,
        lastChecked: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.lastChecked = lastChecked
    }
}

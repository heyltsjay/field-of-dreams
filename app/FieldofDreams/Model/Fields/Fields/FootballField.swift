//
//  FootballField.swift
//  FieldofDreams
//
//  Created by Jason Clark on 8/2/17.
//

import Foundation

struct FootballField: EndzoneField {
    var unit: UnitLength = .yards
    var endzoneDepth: Double = 10
    var playingFieldProper: Double = 100
    var width: Double = 53 + 1/3
}

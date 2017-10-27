//
//  SmallTestField.swift
//  FieldofDreams
//
//  Created by Jason Clark on 8/2/17.
//

import Foundation

struct SmallTestField: EndzoneField {
    var unit: UnitLength = .inches
    var width = 40.0
    var endzoneDepth = 25.0
    var playingFieldProper = 70.0
}

struct ShoeField: Field {
    var unit: UnitLength = .inches
    var verticies: [Point] = [(0,0)]
    var lines: [Line] = []
}

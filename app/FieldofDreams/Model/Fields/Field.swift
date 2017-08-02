//
//  Field.swift
//  FieldofDreams
//
//  Created by Jason Clark on 7/28/17.
//

import ARKit

typealias Point = (x: Double, y: Double)
typealias Line = (start: Point, end: Point)

protocol Field {
    var unit: UnitLength { get }
    var verticies: [Point] { get }
    var lines: [Line] { get }
}

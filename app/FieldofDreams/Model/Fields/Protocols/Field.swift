//
//  Field.swift
//  FieldofDreams
//
//  Created by Jason Clark on 7/28/17.
//

import Foundation

typealias Point = (x: Double, y: Double)

protocol Field {
    var unit: UnitLength { get }
    var verticies: [Point] { get }
}

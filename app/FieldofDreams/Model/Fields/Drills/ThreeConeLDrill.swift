//
//  ThreeConeLDrill.swift
//  FieldofDreams
//
//  Created by Jason Clark on 8/2/17.
//
//
//
/*       3 Cone L Drill

        ( )-------( )
         |
         |
   ^     |
   |    ( )
   |
   +------>

 */


import Foundation

struct ThreeConeLDrill: Field {
    var unit: UnitLength = .yards

    var verticies: [Point] = [(0, 0),
                              (0, 5),
                              (5, 5)]

    var lines: [Line] = []
}

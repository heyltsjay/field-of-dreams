//
//  EndzoneField.swift
//  FieldofDreams
//
//  Created by Jason Clark on 7/28/17.
//

import Foundation

protocol EndzoneField: Field {
    var width: Double { get }
    var endzoneDepth: Double { get }
    var playingFieldProper: Double { get }
}

extension EndzoneField {

    var verticies: [Point] {
        return [
            (0, 0),
            (0, endzoneDepth),
            (width, 0),
            (width, endzoneDepth),

            (0, endzoneDepth + playingFieldProper),
            (0, 2 * endzoneDepth + playingFieldProper),
            (width, endzoneDepth + playingFieldProper),
            (width, 2 * endzoneDepth + playingFieldProper),
        ]
    }

}

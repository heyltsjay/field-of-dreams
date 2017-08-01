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
            (0, length),
            (width, endzoneDepth + playingFieldProper),
            (width, length),
        ]
    }

    fileprivate var length: Double {
        return 2 * endzoneDepth + playingFieldProper
    }

    var lines: [Line] {
        return [
            (start: (0,0), end: (0, length)), // near sideline
            (start: (0,0), end: (width, 0)), // near baseline
            (start: (0, endzoneDepth), end: (width, endzoneDepth)), // near endzone

            (start: (width, 0), end: (width, length)), // far sideline
            (start: (0, length), end: (width, length)), // far baseline
            (start: (0, endzoneDepth + playingFieldProper), end: (width, endzoneDepth + playingFieldProper)), // far endzone
        ]
    }

}

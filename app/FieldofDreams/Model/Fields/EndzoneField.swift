//
//  EndzoneField.swift
//  FieldofDreams
//
//  Created by Jason Clark on 7/28/17.
//

/*           EndzoneField

        (p3)-------------(p4)
         |     endzone     |
        (p2)-------------(p5)
         |                 |
         |     playing     |
         |      field      |
         |      proper     |
         |                 |
        (p1)-------------(p6)
   ^     |     endzone     |
   |    (p0)-------------(p7)
   |
   +------>

 */

import Foundation

protocol EndzoneField: Field {
    var width: Double { get }
    var endzoneDepth: Double { get }
    var playingFieldProper: Double { get }
}

extension EndzoneField {

    var verticies: [Point] {
        return [p0, p1, p2, p3, p4, p5, p6, p7]
    }

    var lines: [Line] {
        return [
            //sidelines
            (p0, p3),
            (p4, p7),

            //baselines
            (p0, p7),
            (p3, p4),

            //endzones
            (p1, p6),
            (p2, p5)
        ]
    }

}

fileprivate extension EndzoneField {

    fileprivate var length: Double {
        return 2 * endzoneDepth + playingFieldProper
    }

    var p0: Point { return (0,     0) }
    var p1: Point { return (0,     endzoneDepth) }
    var p2: Point { return (0,     endzoneDepth + playingFieldProper) }
    var p3: Point { return (0,     length) }
    var p4: Point { return (width, length) }
    var p5: Point { return (width, endzoneDepth + playingFieldProper) }
    var p6: Point { return (width, endzoneDepth) }
    var p7: Point { return (width, 0) }
}

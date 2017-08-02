//
//  Cone.swift
//  FieldofDreams
//
//  Created by Jason Clark on 8/2/17.
//

import ARKit

class Cone: VirtualObject {

    override init() {
        super.init(modelName: "cone", fileExtension: "scn", thumbImageFilename: "cone", title: "Cone")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

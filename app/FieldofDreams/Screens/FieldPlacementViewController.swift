//
//  FieldPlacementViewController.swift
//  FieldofDreams
//
//  Created by Jason Clark on 7/28/17.
//

import ARKit
import Anchorage
import SceneKit

class FieldPlacementViewController: ARSceneViewController {

    let field: SCNNode = {
        let field = ThreeConeLDrill()
        return field.node
    }()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        addChildNodeAtFocus(field)
    }

}

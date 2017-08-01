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
        let field = UltimateFrisbeeField()
        return field.node
    }()

}

extension FieldPlacementViewController {

    func setNewVirtualObjectPosition(_ pos: SCNVector3?) {
        guard let cameraTransform = sceneView.session.currentFrame?.camera.transform else {
            return
        }
        let pos = pos ?? SCNVector3Zero
        let cameraWorldPos = SCNVector3.positionFromTransform(cameraTransform)
        let cameraToPosition = pos - cameraWorldPos
        let origin = cameraWorldPos + cameraToPosition
        field.position = origin
        sceneView.scene.rootNode.addChildNode(field)
    }

}

extension FieldPlacementViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.setNewVirtualObjectPosition(self.focusSquare.lastPosition)
    }

}

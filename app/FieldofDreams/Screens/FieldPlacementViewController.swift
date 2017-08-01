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

    var field: Field = UltimateFrisbeeField()
    var cones: [VirtualObject] = []

}

extension FieldPlacementViewController {

    func addCones() {
        cones.forEach { cone in
            cone.removeFromParentNode()
            cone.unloadModel()
        }
        cones = []
        // Load the content asynchronously.
        DispatchQueue.global().async {
            self.cones = self.field.verticies.map { _ in
                let object = Lamp()
                object.loadModel()
                return object
            }

            DispatchQueue.main.async {
                self.setNewVirtualObjectPosition(self.focusSquare.lastPosition)
            }
        }
    }

    func setNewVirtualObjectPosition(_ pos: SCNVector3?) {
        guard let cameraTransform = sceneView.session.currentFrame?.camera.transform else {
            return
        }
        let pos = pos ?? SCNVector3Zero
        let cameraWorldPos = SCNVector3.positionFromTransform(cameraTransform)
        let cameraToPosition = pos - cameraWorldPos
        let origin = cameraWorldPos + cameraToPosition
        cones.enumerated().forEach() { idx, cone in
            let vertex = field.verticies[idx]
            let x = Measurement<UnitLength>(value: vertex.x, unit: field.unit).converted(to: .meters).value
            let y = Measurement<UnitLength>(value: vertex.y, unit: field.unit).converted(to: .meters).value
            cone.position = origin + SCNVector3(x, 0, y)

            let cylinder: SCNNode = {
                let geometry = SCNCylinder(radius: 0.02, height: 2)
                let cylinder = SCNNode(geometry: geometry)
                cylinder.position = cone.position
                cylinder.pivot = SCNMatrix4MakeTranslation(0, -Float(geometry.height / 2), 0)
                return cylinder
            }()

            sceneView.scene.rootNode.addChildNode(cylinder)
            if cone.parent == nil {
                sceneView.scene.rootNode.addChildNode(cone)
            }
        }
    }

}

extension FieldPlacementViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         addCones()
    }

}

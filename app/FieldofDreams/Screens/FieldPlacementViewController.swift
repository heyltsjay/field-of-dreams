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

        field.lines.forEach { line in
            let (x1, y1, x2, y2) = { () -> (Double, Double, Double, Double) in
                let scaled = [line.start.x, line.start.y, line.end.x, line.end.y].map {
                    return Measurement<UnitLength>(value: $0, unit: field.unit).converted(to: .meters).value
                }
                return (scaled[0], scaled[1], scaled[2], scaled[3])
            }()

            let line: SCNNode = {
                let geometry = SCNBox(width: 0.06, height: 0.01, length: CGFloat(hypot(x1-x2, y1-y2)), chamferRadius: 0)
                let line = SCNNode(geometry: geometry)
                line.position = origin + SCNVector3(x1, 0, y1)
                line.rotation = SCNVector4Make(0, 1, 0, Float(atan2(x2-x1, y2-y1)))
                line.pivot = SCNMatrix4MakeTranslation(0, Float(-geometry.height/2), Float(-geometry.length/2))
                return line
            }()

            sceneView.scene.rootNode.addChildNode(line)
        }
    }

}

extension FieldPlacementViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         addCones()
    }

}

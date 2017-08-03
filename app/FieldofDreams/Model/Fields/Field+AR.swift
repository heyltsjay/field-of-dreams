//
//  Field+AR.swift
//  FieldofDreams
//
//  Created by Jason Clark on 8/1/17.
//

import ARKit
import SceneKit

extension Field {

    var node: SCNNode {
        let fieldNode = SCNNode()

        verticies.forEach { vertex in
            let vertextNode = SCNNode()
            vertextNode.position = SCNVector3(scaled(vertex.x), 0, scaled(-vertex.y))

            vertextNode.addChildNode(ConeNode())
            //TODO: Pillars only show when they are some distance away
            //vertextNode.addChildNode(PillarNode())

            fieldNode.addChildNode(vertextNode)
        }

        lines.forEach { line in
            fieldNode.addChildNode(LineNode(line))
        }

        return fieldNode
    }

}

fileprivate extension Field {

    func ConeNode() -> SCNNode {
        return Cone()
    }

    func PillarNode() -> SCNNode {
        let height = CGFloat(10)
        let radius = CGFloat(0.1)
        let cylinder = SCNNode(
            geometry: SCNCylinder(radius: radius,
                                  height: height)
        )
        cylinder.opacity = 0.2
        cylinder.geometry?.firstMaterial?.diffuse.contents = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.1294117647, alpha: 1)
        cylinder.pivot = SCNMatrix4MakeTranslation(0, -Float(height / 2), 0)
        cylinder.position = SCNVector3(0, 0, 0)
        return cylinder
    }

    func LineNode(_ line: Line) -> SCNNode {
        let x1 = scaled(line.start.x)
        let x2 = scaled(line.end.x)
        let y1 = scaled(-line.start.y)
        let y2 = scaled(-line.end.y)
        let length = CGFloat(hypot(x1 - x2, y1 - y2))
        let rotation = atan2(x2 - x1, y2 - y1)
        let width = CGFloat(0.06)
        let height = CGFloat(0.01)
        let lineNode = SCNNode(
            geometry: SCNBox(width: width,
                             height: height,
                             length: length,
                             chamferRadius: 0)
        )
        lineNode.opacity = 0.7
        lineNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        lineNode.position = SCNVector3(x1, 0, y1)
        lineNode.rotation = SCNVector4Make(0, 1, 0, Float(rotation))
        lineNode.pivot = SCNMatrix4MakeTranslation(0, Float(height/2), Float(-length/2))
        return lineNode
    }

}

extension Field {

    func scaled(_ value: Double) -> Double {
        return Measurement<UnitLength>(value: value, unit: unit)
            .converted(to: .meters)
            .value
    }

}

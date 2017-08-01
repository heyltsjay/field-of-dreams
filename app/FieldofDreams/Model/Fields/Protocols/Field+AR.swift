//
//  Field+AR.swift
//  FieldofDreams
//
//  Created by Jason Clark on 8/1/17.
//

import Foundation

extension Field {

    var node: SCNNode {
        let fieldNode = SCNNode()

        verticies.forEach { vertex in
            //TODO: Move away from VirtualObject
            let vertextNode = SCNNode()
            vertextNode.position = SCNVector3(scaled(vertex.x), 0, scaled(vertex.y))

            // cone
            vertextNode.addChildNode({
                let cone = Lamp()
                cone.loadModel()
                return cone
                }())

            // pillar
            vertextNode.addChildNode({
                let height = CGFloat(2)
                let radius = CGFloat(0.02)
                let cylinder = SCNNode(
                    geometry: SCNCylinder(radius: radius,
                                          height: height)
                )
                cylinder.pivot = SCNMatrix4MakeTranslation(0, -Float(height / 2), 0)
                return cylinder
                }())

            fieldNode.addChildNode(vertextNode)
        }

        lines.forEach { line in
            let x1 = scaled(line.start.x)
            let x2 = scaled(line.end.x)
            let y1 = scaled(line.start.y)
            let y2 = scaled(line.end.y)
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
            lineNode.position = SCNVector3(x1, 0, y1)
            lineNode.rotation = SCNVector4Make(0, 1, 0, Float(rotation))
            lineNode.pivot = SCNMatrix4MakeTranslation(0, Float(-height/2), Float(-length/2))
            fieldNode.addChildNode(lineNode)
        }
        return fieldNode
    }

}

extension Field {

    func scaled(_ value: Double) -> Double {
        return Measurement<UnitLength>(value: value, unit: unit)
            .converted(to: .meters)
            .value
    }

}

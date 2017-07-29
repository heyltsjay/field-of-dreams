//
//  FieldPlacementViewController.swift
//  FieldofDreams
//
//  Created by Jason Clark on 7/28/17.
//

import ARKit
import Anchorage
import SceneKit

class FieldPlacementViewController: UIViewController {

    var field: Field = UltimateFrisbeeField()

    fileprivate let sceneView = ARSCNView()
    var focusSquare = FocusSquare()
    var cones: [VirtualObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self

        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            camera.wantsExposureAdaptation = true
            camera.exposureOffset = -1
            camera.minimumExposure = -1
        }

        updateFocusSquare()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sceneView.session.pause()
    }
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
                if let lastFocusSquarePos = self.focusSquare.lastPosition {
                    self.setNewVirtualObjectPosition(lastFocusSquarePos)
                } else {
                    self.setNewVirtualObjectPosition(SCNVector3Zero)
                }
            }
        }
    }

    func setNewVirtualObjectPosition(_ pos: SCNVector3) {
        guard let cameraTransform = sceneView.session.currentFrame?.camera.transform else {
            return
        }

        let cameraWorldPos = SCNVector3.positionFromTransform(cameraTransform)
        let cameraToPosition = pos - cameraWorldPos
        let origin = cameraWorldPos + cameraToPosition
        cones.enumerated().forEach() { idx, cone in
            let vertex = field.verticies[idx]
            let x = Measurement<UnitLength>(value: vertex.x, unit: field.unit).converted(to: .meters).value
            let y = Measurement<UnitLength>(value: vertex.y, unit: field.unit).converted(to: .meters).value
            cone.position = origin + SCNVector3(x, 0, y)
            if cone.parent == nil {
                sceneView.scene.rootNode.addChildNode(cone)
            }
        }
    }

}

extension FieldPlacementViewController {

    override func loadView() {
        view = UIView()

        view.addSubview(sceneView)
        sceneView.edgeAnchors == view.edgeAnchors
    }

    var screenCenter: CGPoint {
        return CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
    }

    func updateFocusSquare() {
        if focusSquare.parent == nil {
            sceneView.scene.rootNode.addChildNode(focusSquare)
        }
        if !cones.isEmpty && sceneView.isNode(cones.first!, insideFrustumOf: sceneView.pointOfView!) {
            focusSquare.hide()
        }
        else {
            focusSquare.unhide()
        }
        let (worldPos, planeAnchor, _) = worldPositionFromScreenPosition(screenCenter, objectPos: focusSquare.position)
        if let worldPos = worldPos {
            focusSquare.update(for: worldPos, planeAnchor: planeAnchor, camera: sceneView.session.currentFrame?.camera)
        }
    }

}

extension FieldPlacementViewController {

    func worldPositionFromScreenPosition(_ position: CGPoint,
                                         objectPos: SCNVector3?,
                                         infinitePlane: Bool = false) -> (position: SCNVector3?, planeAnchor: ARPlaneAnchor?, hitAPlane: Bool) {

        // -------------------------------------------------------------------------------
        // 1. Always do a hit test against exisiting plane anchors first.
        //    (If any such anchors exist & only within their extents.)

        let planeHitTestResults = sceneView.hitTest(position, types: .existingPlaneUsingExtent)
        if let result = planeHitTestResults.first {

            let planeHitTestPosition = SCNVector3.positionFromTransform(result.worldTransform)
            let planeAnchor = result.anchor

            // Return immediately - this is the best possible outcome.
            return (planeHitTestPosition, planeAnchor as? ARPlaneAnchor, true)
        }

        // -------------------------------------------------------------------------------
        // 2. Collect more information about the environment by hit testing against
        //    the feature point cloud, but do not return the result yet.

        var featureHitTestPosition: SCNVector3?
        var highQualityFeatureHitTestResult = false

        let highQualityfeatureHitTestResults = sceneView.hitTestWithFeatures(position, coneOpeningAngleInDegrees: 18, minDistance: 0.2, maxDistance: 2.0)

        if !highQualityfeatureHitTestResults.isEmpty {
            let result = highQualityfeatureHitTestResults[0]
            featureHitTestPosition = result.position
            highQualityFeatureHitTestResult = true
        }

        // -------------------------------------------------------------------------------
        // 3. If desired or necessary (no good feature hit test result): Hit test
        //    against an infinite, horizontal plane (ignoring the real world).

        if infinitePlane || !highQualityFeatureHitTestResult {

            let pointOnPlane = objectPos ?? SCNVector3Zero

            let pointOnInfinitePlane = sceneView.hitTestWithInfiniteHorizontalPlane(position, pointOnPlane)
            if pointOnInfinitePlane != nil {
                return (pointOnInfinitePlane, nil, true)
            }
        }

        // -------------------------------------------------------------------------------
        // 4. If available, return the result of the hit test against high quality
        //    features if the hit tests against infinite planes were skipped or no
        //    infinite plane was hit.

        if highQualityFeatureHitTestResult {
            return (featureHitTestPosition, nil, false)
        }

        // -------------------------------------------------------------------------------
        // 5. As a last resort, perform a second, unfiltered hit test against features.
        //    If there are no features in the scene, the result returned here will be nil.

        let unfilteredFeatureHitTestResults = sceneView.hitTestWithFeatures(position)
        if !unfilteredFeatureHitTestResults.isEmpty {
            let result = unfilteredFeatureHitTestResults[0]
            return (result.position, nil, false)
        }

        return (nil, nil, false)
    }

}

extension FieldPlacementViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.updateFocusSquare()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         addCones()
    }

}

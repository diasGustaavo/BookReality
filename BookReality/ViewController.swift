//
//  ViewController.swift
//  BookReality
//
//  Created by Gustavo Dias on 18/01/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Books", bundle: Bundle.main) {
            configuration.detectionImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            print("Images Sucessfully Added")
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.width)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = .pi / 2
            
            node.addChildNode(planeNode)
            
            if imageAnchor.referenceImage.name == "danbrown_inferno" {
                let sceneName = "dantesMask"
                guard let pokeScene = SCNScene(named: "art.scnassets/\(sceneName).scn") else {
                    fatalError("no \(sceneName) scene detected!")
                }
                
                guard let pokeNode = pokeScene.rootNode.childNodes.first else {
                    fatalError("no \(sceneName) node detected!")
                }
                
                planeNode.addChildNode(pokeNode)
            }
            
            if imageAnchor.referenceImage.name == "history" {
                let sceneName = "rosettaStone"
                guard let pokeScene = SCNScene(named: "art.scnassets/\(sceneName).scn") else {
                    fatalError("no \(sceneName) scene detected!")
                }
                
                guard let pokeNode = pokeScene.rootNode.childNodes.first else {
                    fatalError("no \(sceneName) node detected!")
                }
                
                planeNode.addChildNode(pokeNode)
            }
        }
        
        return node
    }
}

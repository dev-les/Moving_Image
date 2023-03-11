//
//  ViewController.swift
//  Moving_Image
//
//  Created by Luis Sanchez on 1/4/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var player : AVPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/imageScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let image  =  ARReferenceImage.referenceImages(inGroupNamed: "Images", bundle: Bundle.main) else {
            print("No Image found")
            return
        }
        
        configuration.trackingImages = image

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            let videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: "IMG_1842", ofType: "mov")!)
            player = AVPlayer(url: videoURL)
            
            let videoPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            videoPlane.firstMaterial?.diffuse.contents = player
            let videoNode = SCNNode(geometry: videoPlane)
            videoNode.eulerAngles.x = -.pi / 2
            node.addChildNode(videoNode)
            player.play()
            
        }
        return node
    }

 
}

//
//  GameViewController.swift
//  MODevTest
//
//  Created by James Hillhouse IV on 6/17/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit




class GameViewController: UIViewController {

    var overlayScene: SKScene = SKScene()
    var lightTextNode: SKLabelNode = SKLabelNode()
    var lightNode: SCNNode = SCNNode()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/cubes.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        
        // Create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .directional
        lightNode.light!.intensity = 1000.0
        lightNode.light!.categoryBitMask = 2
        lightNode.light!.castsShadow = true
        lightNode.position = SCNVector3(x: 0, y: 0, z: 8)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        _ = scene.rootNode.childNode(withName: "Cubes", recursively: true)!

        let scnCubeNode        = SCNNode()
        scnCubeNode.geometry   = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)
        scnCubeNode.geometry!.firstMaterial?.lightingModel = .physicallyBased
        scnCubeNode.geometry!.firstMaterial?.diffuse.contents = UIColor.red
        scnCubeNode.geometry!.firstMaterial?.metalness.contents = 1.0
        scnCubeNode.geometry!.firstMaterial?.roughness.contents = 0
        scnCubeNode.simdPosition = simd_float3(x: 0.0, y: 0.0, z: 0.0)
        scene.rootNode.addChildNode(scnCubeNode)


        // Create SKScene
        overlayScene = SKScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
//        let overlayScene = SKScene(size: CGSize(width: 1000, height: 1000))


        // Add-in SKLabelNode for the title
        let headerTextNode = SKLabelNode(fontNamed: "HelveticaNeue")
        headerTextNode.text = "Light Rendering Issues"
        headerTextNode.fontSize = 24
        headerTextNode.fontColor = SKColor.black
        headerTextNode.position = CGPoint(x: 190.0, y: 725.0)
        overlayScene.addChild(headerTextNode)

        // Add-in SKLabelNode for the light currently in use
        lightTextNode = SKLabelNode(fontNamed: "HelveticaNeue")
        lightTextNode.text = "Directional"
        lightTextNode.fontSize = 20
        lightTextNode.fontColor = .black
        lightTextNode.position = CGPoint(x: 180, y: 150)
        overlayScene.addChild(lightTextNode)


        //Add-in the SKSpriteNode for the button to change the light type
        let lightImage = SKSpriteNode(imageNamed: "lightbulb")
        lightImage.name = "light"
        lightImage.xScale = 2.0
        lightImage.yScale = 2.0
        lightImage.position = CGPoint(x: 190, y: 100)
        overlayScene.addChild(lightImage)

        // animate the 3d object
        //cube.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene

        // Add overlayScene to scene
        scnView.overlaySKScene = overlayScene

        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}

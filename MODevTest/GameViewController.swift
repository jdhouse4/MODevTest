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

    var lightBulbImageNode: SKSpriteNode = SKSpriteNode()

    var lightIndex: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/cubes.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 8)
        
        // Create and add to the scene that will be changed to demonstrate the rendering issues.
        lightNode.light = SCNLight()
        lightNode.light!.type = .directional
        lightNode.light!.intensity = 2000.0
        lightNode.light!.categoryBitMask = 2
        lightNode.light!.castsShadow = true
        lightNode.position = SCNVector3(x: 0, y: 0, z: 15)
        scene.rootNode.addChildNode(lightNode)

        // Retrieve the cubes node that contains the imported cubes.
        _ = scene.rootNode.childNode(withName: "Cubes", recursively: true)!

        let scnCubeTexturedWithZeroRoughnessNode        = SCNNode()
        scnCubeTexturedWithZeroRoughnessNode.geometry   = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)
        scnCubeTexturedWithZeroRoughnessNode.geometry!.firstMaterial?.lightingModel = .physicallyBased
        scnCubeTexturedWithZeroRoughnessNode.geometry!.firstMaterial?.diffuse.contents = UIImage(named: "wood")
        scnCubeTexturedWithZeroRoughnessNode.geometry!.firstMaterial?.metalness.contents = 1.0
        scnCubeTexturedWithZeroRoughnessNode.geometry!.firstMaterial?.roughness.contents = 0.0
        scnCubeTexturedWithZeroRoughnessNode.categoryBitMask = 2
        scnCubeTexturedWithZeroRoughnessNode.simdPosition = simd_float3(x: 0.75, y: 1.875, z: 0.0)
        scene.rootNode.addChildNode(scnCubeTexturedWithZeroRoughnessNode)


        let scnCubeTexturedWithRoughnessNode        = SCNNode()
        scnCubeTexturedWithRoughnessNode.geometry   = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)
        scnCubeTexturedWithRoughnessNode.geometry!.firstMaterial?.lightingModel = .physicallyBased
        scnCubeTexturedWithRoughnessNode.geometry!.firstMaterial?.diffuse.contents = UIImage(named: "wood")
        scnCubeTexturedWithRoughnessNode.geometry!.firstMaterial?.metalness.contents = 1.0
        scnCubeTexturedWithRoughnessNode.geometry!.firstMaterial?.roughness.contents = 0.5
        scnCubeTexturedWithRoughnessNode.categoryBitMask = 2
        scnCubeTexturedWithRoughnessNode.simdPosition = simd_float3(x: 0.75, y: 0.625, z: 0.0)
        scene.rootNode.addChildNode(scnCubeTexturedWithRoughnessNode)


        let scnCubeColorWithZeroRoughnessNode        = SCNNode()
        scnCubeColorWithZeroRoughnessNode.geometry   = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)
        scnCubeColorWithZeroRoughnessNode.geometry!.firstMaterial?.lightingModel = .physicallyBased
        scnCubeColorWithZeroRoughnessNode.geometry!.firstMaterial?.diffuse.contents = UIImage(named: "wood")
        scnCubeColorWithZeroRoughnessNode.geometry!.firstMaterial?.metalness.contents = 1.0
        scnCubeColorWithZeroRoughnessNode.geometry!.firstMaterial?.roughness.contents = 0.0
        scnCubeColorWithZeroRoughnessNode.categoryBitMask = 2
        scnCubeColorWithZeroRoughnessNode.simdPosition = simd_float3(x: 0.75, y: -0.625, z: 0.0)
        scene.rootNode.addChildNode(scnCubeColorWithZeroRoughnessNode)


        let scnCubeColorWithRoughnessNode        = SCNNode()
        scnCubeColorWithRoughnessNode.geometry   = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)
        scnCubeColorWithRoughnessNode.geometry!.firstMaterial?.lightingModel      = .physicallyBased
        scnCubeColorWithRoughnessNode.geometry!.firstMaterial?.diffuse.contents   = UIColor.red
        scnCubeColorWithRoughnessNode.geometry!.firstMaterial?.metalness.contents = 1.0
        scnCubeColorWithRoughnessNode.geometry!.firstMaterial?.roughness.contents = 0.5
        scnCubeColorWithRoughnessNode.categoryBitMask = 2
        scnCubeColorWithRoughnessNode.simdPosition = simd_float3(x: 0.75, y: -1.875, z: 0.0)
        scene.rootNode.addChildNode(scnCubeColorWithRoughnessNode)

        // Find the center of the screen
        let screenCenter: CGPoint = self.view.center

        let screenSize: CGSize = CGSize(width: self.view.frame.width, height: self.view.frame.size.height)

        // Create SKScene
        overlayScene = SKScene(size: CGSize(width: screenSize.width, height: screenSize.height))

        // Add-in SKLabelNode for the title
        let headerTextNode = SKLabelNode(fontNamed: "HelveticaNeue")
        headerTextNode.text = "Light Rendering Issues"
        headerTextNode.fontSize = 24
        headerTextNode.fontColor = SKColor.black
        headerTextNode.position = CGPoint(x: screenCenter.x, y: screenSize.height - 75.0)
        overlayScene.addChild(headerTextNode)

        //Add-in the SKSpriteNode for the button to change the light type
        lightBulbImageNode = SKSpriteNode(imageNamed: "lightbulb")
        lightBulbImageNode.name = "light"
        lightBulbImageNode.xScale = 2.0
        lightBulbImageNode.yScale = 2.0
        lightBulbImageNode.position = CGPoint(x: screenCenter.x, y: 100)
        overlayScene.addChild(lightBulbImageNode)

        // Add-in SKLabelNode for the light currently in use
        lightTextNode = SKLabelNode(fontNamed: "HelveticaNeue")
        lightTextNode.text = lightNode.light!.type.rawValue
        lightTextNode.fontSize = 20
        lightTextNode.fontColor = .black
        lightTextNode.position = CGPoint(x: screenCenter.x,
                                         y:  lightBulbImageNode.position.y + lightBulbImageNode.frame.size.height / 2.0)
        overlayScene.addChild(lightTextNode)

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
        // Retrieve the current scene's SKScene
        let scnOverlayScene = overlayScene
        
        // At what CGPoint did the tap occur?
        let p = gestureRecognize.location(in: self.view)

        // Convert the node tapped from view coords to scene coords.
        let hitResult = scnOverlayScene.convertPoint(fromView: p)

        // Now determine which node was tapped.
        let hitNode = scnOverlayScene.atPoint(hitResult)

        // Give the user some indication that the button was tapped.
        if hitNode.name == "light"
        {
            // Highlight the lightBulbImageNode
            // Set-up a sequenc of SKAction events.
            let lightAction = SKAction.sequence(
                [SKAction.scaleX(to: 0, duration: 0.05),
                 SKAction.scale(to: 2, duration: 0.05),
            ])

            // Run the SKAction sequence.
            lightBulbImageNode.run(lightAction)

            // Increment the light type
            lightIndex += 1

            if lightIndex == 4
            {
                lightIndex = 0
            }

            switch lightIndex {
            case 0:
                lightNode.light?.type = .directional
                lightTextNode.text = lightNode.light?.type.rawValue
            case 1:
                lightNode.light?.type = .spot
                lightTextNode.text = lightNode.light?.type.rawValue
            case 2:
                lightNode.light?.type = .omni
                lightTextNode.text = lightNode.light?.type.rawValue
            case 3:
                lightNode.light?.type = .ambient
                lightTextNode.text = lightNode.light?.type.rawValue
            default:
                lightNode.light?.type = .directional
                lightTextNode.text = lightNode.light?.type.rawValue
            }
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

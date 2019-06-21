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

    var scnView: SCNView = SCNView()

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
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        
        // Create and add a light to the scene
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


        // Find the center of the screen
        let screenCenter: CGPoint = self.view.center
        print("screenCenter: \(screenCenter)")

        let screenSize: CGSize = CGSize(width: self.view.frame.width, height: self.view.frame.size.height)
        print("screenSize: \(screenSize)")

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
        lightTextNode.text = "Directional"
        lightTextNode.fontSize = 20
        lightTextNode.fontColor = .black
        lightTextNode.position = CGPoint(x: screenCenter.x,
                                         y:  lightBulbImageNode.position.y + lightBulbImageNode.frame.size.height / 2.0)
        overlayScene.addChild(lightTextNode)

        // animate the 3d object
        //cube.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        scnView = self.view as! SCNView
        
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
        let scnOverlayScene = overlayScene
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: self.view)

        let hitResult = scnOverlayScene.convertPoint(fromView: p)

        let hitNode = scnOverlayScene.atPoint(hitResult)

        if hitNode.name == "light"
        {
            // Highlight the lightBulbImageNode
            let lightAction = SKAction.sequence(
                [SKAction.scaleX(to: 0, duration: 0.05),
                 SKAction.scale(to: 2, duration: 0.05),
            ])

            lightBulbImageNode.run(lightAction)

            guard let path = Bundle.main.path(forResource: "light_switch", ofType: "mp3") else {
                print("The path could not be created.")
                return
            }

            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: path)
            {
                print("Great news! Your sound file \"light_switch.mp3\" exists.")
            }
            else
            {
                print("Your file \"ligh_switch.mp3\" isn't visible even though it's in the bundle.")
            }

            // Play a sound
            guard let soundFileURL = Bundle.main.url(forResource: "click", withExtension: "caf") else {
                print("Oopsie, no sound file \"click.caf\" in the bundle...even though it's there!")
                return
            }
            print("Sound file \"click.caf\" loaded: \(soundFileURL.relativeString)")


            // Change the light type
            lightIndex += 1

            if lightIndex == 4
            {
                lightIndex = 0
            }

            switch lightIndex {
            case 0:
                lightNode.light?.type = .directional
                lightTextNode.text = "Directional"
            case 1:
                lightNode.light?.type = .spot
                lightTextNode.text = "Spot"
            case 2:
                lightNode.light?.type = .omni
                lightTextNode.text = "Omni"
            case 3:
                lightNode.light?.type = .ambient
                lightTextNode.text = "Ambient"
            default:
                lightNode.light?.type = .directional
                lightTextNode.text = "Directional"
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

//
//  GameViewController.swift
//  adeiladu
//
//  Created by Darius Elphick on 24/09/2019.
//  Copyright © 2019 TenaciousDarius. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 25)
        
        let firstLegoNode = legoBrick()
        firstLegoNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(firstLegoNode);
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        scnView.autoenablesDefaultLighting = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func legoBrick() -> SCNNode {
        let legoUnit = CGFloat(1.6)
        let brickHeight = legoUnit * 6
        let brickWidth = legoUnit * 10
        let studHeight = legoUnit
        let studWidth = legoUnit * 3
        let studX = Float(brickWidth * 0.25)
        let studY = Float((brickHeight / 2) + (studHeight / 2))
        let studZ = Float(brickWidth * -0.25)
        
        
        let firstLegoNode = SCNNode()
    
        let firstLegoCube = SCNBox(width: brickWidth, height:brickHeight, length: brickWidth, chamferRadius: 0)
        firstLegoNode.addChildNode(SCNNode(geometry: firstLegoCube))
        
        let firstLegoStudNode = SCNNode(geometry: SCNCylinder(radius: studWidth / 2.0, height: studHeight))
        firstLegoStudNode.position = SCNVector3Make(
            studX,
            studY,
            studX
        )
        firstLegoNode.addChildNode(firstLegoStudNode)
        
        let secondLegoStudNode = SCNNode(geometry: SCNCylinder(radius: studWidth / 2.0, height: studHeight))
        secondLegoStudNode.position = SCNVector3Make(
            studX,
            studY,
            studZ
        )
        firstLegoNode.addChildNode(secondLegoStudNode)
        
        let thirdLegoStudNode = SCNNode(geometry: SCNCylinder(radius: studWidth / 2.0, height: studHeight))
        thirdLegoStudNode.position = SCNVector3Make(
            studZ,
            studY,
            studX
        )
        firstLegoNode.addChildNode(thirdLegoStudNode)
        
        let fourthLegoStudNode = SCNNode(geometry: SCNCylinder(radius: studWidth / 2.0, height: studHeight))
        fourthLegoStudNode.position = SCNVector3Make(
            studZ,
            studY,
            studZ
        )
        firstLegoNode.addChildNode(fourthLegoStudNode)
        
        return firstLegoNode
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

}

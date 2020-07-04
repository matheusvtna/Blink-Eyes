//
//  GameViewController.swift
//  Rainbrow
//
//  Created by Matheus Andrade on 03/07/20.
//  Copyright © 2020 Matheus Andrade. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class GameViewController: UIViewController, ARSessionDelegate {

    var gameScene: GameScene!
    var session: ARSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                gameScene = scene
                // Set the scale mode to scale to fit the window
                gameScene.scaleMode = .aspectFill
            
                // Present the scene
                view.presentScene(gameScene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            session = ARSession()
            session.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARFaceTrackingConfiguration.isSupported else {print("iPhone X required"); return}
        
        let configuration = ARFaceTrackingConfiguration()
        
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let faceAnchor = anchors.first as? ARFaceAnchor{
            update(withFaceAnchor: faceAnchor)
        }
    }
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor){
        let blendShapes:[ARFaceAnchor.BlendShapeLocation:Any] = faceAnchor.blendShapes
       
        guard let browInnerUp = blendShapes[.browInnerUp] as? Float else {return}
        
        print(browInnerUp)
        
        if browInnerUp > 0.5 {
            print("Up")
            gameScene.updatePlayer(state: .up)
        }
        else if browInnerUp < 0.06 {
            print("Down")
            gameScene.updatePlayer(state: .down)
        }
        else{
            print("Neutral")
            gameScene.updatePlayer(state: .neutral)
        }
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

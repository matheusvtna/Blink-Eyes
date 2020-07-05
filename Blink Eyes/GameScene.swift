//
//  GameScene.swift
//  Rainbrow
//
//  Created by Matheus Andrade on 03/07/20.
//  Copyright © 2020 Matheus Andrade. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private var playerNode: Player?
    private var coinNode: SKSpriteNode?
    private var enemyNode: SKSpriteNode?

    private var scoreLabelNode: SKLabelNode?
    
    var moving: Bool = false
    var coin: Bool = true

    var generator: UIImpactFeedbackGenerator!

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        playerNode = self.childNode(withName: "player") as? Player
        coinNode = self.childNode(withName: "coin") as? SKSpriteNode
        enemyNode = self.childNode(withName: "enemy") as? SKSpriteNode
        
        scoreLabelNode = self.childNode(withName: "scoreLabel") as? SKLabelNode

        Score.shared.amount = 0
        
        generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()

    }

    func updatePlayer(state: PlayerState){
        if !moving{
            movePlayer(state: state)
        }
    }

    func movePlayer(state: PlayerState){
        if let player = playerNode{

            player.texture = SKTexture(imageNamed: state.rawValue)

            var direction: CGFloat = 0

            switch state {
            case .neutral:
                direction = 0
            case .down:
                direction = -160
            case .up:
                direction = 160
            }

            if Int(player.position.y) + Int(direction) >= -587 && Int(player.position.y) + Int(direction) <= 373{

                moving = true
                let moveAction = SKAction.move(by: CGVector(dx: 0, dy: direction), duration: 0.3)

                let moveEndedAction = SKAction.run{
                    self.moving = false

                    if direction != 0 {
                        self.generator.impactOccurred()
                    }
                }

                let sequence = SKAction.sequence([moveAction, moveEndedAction])
                player.run(sequence)
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if !coin {
            createReward()
        }
        
        createEnemy()
    }
    
    func createReward(){
        coin = true
        
        let randomInt = Int.random(in: 0..<6)
        var yPosition: CGFloat = 0
        
        switch randomInt {
        case 0:
            yPosition = 213
        case 1:
            yPosition = 53
        default:
            yPosition = 373
        }
        
        coinNode?.position = CGPoint(x: self.frame.size.width/2, y: yPosition)
        
        print("Coin Created")
    }
    
    func createEnemy(){
        //print("Enemy created")
    }

}

extension GameScene: SKPhysicsContactDelegate {
    
    struct Collision {
        
        enum Masks: Int {
            case reward, killing, player
            var bitmask: UInt32 { return 1 << self.rawValue }
        }
        
        let masks: (first: UInt32, second: UInt32)
        
        func matches (_ first: Masks, _ second: Masks) -> Bool {
            return (first.bitmask == masks.first && second.bitmask == masks.second) ||
            (first.bitmask == masks.second && second.bitmask == masks.first)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
                
        print("Colision")
        
        let collision = Collision(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))
        
        if collision.matches(.player, .killing) {
            let die = SKAction.move(to: CGPoint(x: 0, y: 373), duration: 0.0)
            playerNode?.run(die)
                            
            Score.shared.trySaveHighScore()
            Score.shared.amount = 0
            scoreLabelNode?.text = "You lost! Score: \(Score.shared.amount)"
            
            self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
            
        }
        
        if collision.matches(.player, .reward){
            print("Coin collected")
            coin = false
                    
            Score.shared.addScore()
            scoreLabelNode?.text = "Score: \(Score.shared.amount)"
        }
    }
}

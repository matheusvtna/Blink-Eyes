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
    var moving: Bool = false

    var generator: UIImpactFeedbackGenerator!

    override func didMove(to view: SKView) {
        playerNode = self.childNode(withName: "player") as? Player

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

    }

}


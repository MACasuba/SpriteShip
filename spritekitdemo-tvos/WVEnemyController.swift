//
//  WVEnemyController.swift
//  Brick
//
//  Created by william vabrinskas on 12/21/15.
//  Copyright © 2015 William Vabrinskas. All rights reserved.
//

import Foundation
import SpriteKit


class WVEnemyController: NSObject {
    
    var enemy = SKSpriteNode()
    var enemyCat: UInt32 = 0x1 << 0
    var sceneFrame: CGRect = CGRect()
    var parentNode = SKNode()
    var scoreController: WVScoreController = WVScoreController()


    func setupEnemiesInNode (node: SKNode, frame: CGRect) {
        sceneFrame = frame;
        parentNode = node
        scoreController = WVScoreController.init()
        scoreController.setupScoringWithNode(node: node, frame: frame)
        self.layoutEnemy()

    }
    
    //random float generator for scale
    func randomFloatBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    
     func layoutEnemy () {
        
        enemy = SKSpriteNode.init(imageNamed: "asteroid1")
        //enemy.name = "asteroid1"
        enemy.xScale = randomFloatBetweenNumbers(firstNum: 0.2, secondNum: 0.5); //0.5;
        enemy.yScale = enemy.xScale //0.5;
        enemy.zPosition = 2;
        //enemy.physicsBody = SKPhysicsBody.init(rectangleOf:enemy.size); //was rectangular
        
        // Spaceship 1: circular physics body
        //enemy.physicsBody = SKPhysicsBody.init(circleOfRadius: max(enemy.size.width / 2, enemy.size.height / 2))
        enemy.physicsBody = SKPhysicsBody.init(circleOfRadius: enemy.size.width / 2)

 
        enemy.physicsBody?.categoryBitMask = enemyCat
        enemy.physicsBody?.contactTestBitMask = 0x1 << 1
        enemy.physicsBody?.collisionBitMask = 0
        enemy.physicsBody?.usesPreciseCollisionDetection = true
        
        //let lowerBound = UInt32(sceneFrame.minX);  //Original code
        //let upperBound = UInt32(sceneFrame.maxX);  //Original code
        
        let lowerBound = UInt32(sceneFrame.minY);
        let upperBound = UInt32(sceneFrame.maxY);
        
        let num = arc4random_uniform(upperBound) + lowerBound

          enemy.position = CGPoint(x: (sceneFrame.maxX - enemy.size.height),y: CGFloat(num))

        parentNode.addChild(enemy)
    }
    


    
    func updateScore () {
        scoreController.updateScore()
    }
    
    func spawnInterval () -> Double {
        //if score gets gigher, the rocks will come in faster
        let y = scoreController.getScore()  //Original code
        let interval = (y - 250) / -50      //Original code

        let val = 0.1
        if interval <= 0 {
            return val
        }
        return Double(interval)
    }
    
    
    func randomlyGenerateEnemy() {
        self.layoutEnemy()
        let updateScore = SKAction.perform(#selector(WVEnemyController.updateScore), onTarget:self)
        let node: SKSpriteNode = enemy
        let spin:SKAction = SKAction.rotate(byAngle: CGFloat(M_PI), duration:1)
        let spinForever:SKAction = SKAction.repeatForever(spin)
        //let move:SKAction = SKAction.moveTo(y: sceneFrame.minY - enemy.size.height, duration:self.spawnInterval())  //Original code
        let move:SKAction = SKAction.moveTo(x: sceneFrame.minX - enemy.size.width, duration:self.spawnInterval())

        let returnToStart:SKAction = SKAction.removeFromParent()
        node.run(spinForever)
        node.run(move) { () -> Void in
            node.run(updateScore, completion: { () -> Void in
                node.run(returnToStart)
            })
        }

    }
    
    func startTimerForEnemies () {
    
        let spawn:SKAction = SKAction.perform(#selector(WVEnemyController.randomlyGenerateEnemy), onTarget:self)
        let delay:SKAction = SKAction.wait(forDuration: 0.5)
        let spawnThenDelay:SKAction = SKAction.sequence([spawn,delay])
        let spawnThenDelayForever:SKAction = SKAction.repeatForever(spawnThenDelay)
        enemy.run(spawnThenDelayForever, withKey:"enemy")
 
    }
    
    func stopTimerForEnemies () {
        enemy.removeAllActions()
    }
}

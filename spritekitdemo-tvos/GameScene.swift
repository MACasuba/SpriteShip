//
//  GameScene.swift
//  spritekitdemo-tvos
//
//  Created by Razvan on 22/05/2016.
//  Copyright (c) 2016 Razvan Bunea. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {
   
    //var swipeUp = SKAction()
    //var swipeDown = SKAction()
    
    var playExplosion: AVAudioPlayer?
    var ship = SKSpriteNode()
    var wallCat: UInt32 = 0x1 << 2
    var playerCat: UInt32 = 0x1 << 1
    var worldNode = SKNode();
    var enemyController = WVEnemyController()
    var playAgain = SKLabelNode()
    var died = Bool()
    var score = SKLabelNode()
    var topBlock = SKNode()
    var emissionSprite = SKEmitterNode() //vuurtrail van raket
    var explosionSprite = SKEmitterNode() //explosie bij botsing
    var stars = SKEmitterNode() //voor extra sterren
    
    let backgroundVelocity : CGFloat = 3.0

    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor.clear  //was black
        self.initializingScrollingBackground()
        
        // Register Swipe Events
/*
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector(("swipedRight")))
        let directionR = UISwipeGestureRecognizerDirection.right
        swipeRight.direction = directionR
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector(("swipedLeft")))
        let directionL = UISwipeGestureRecognizerDirection.left
        swipeLeft.direction = directionL
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(getter: GameScene.swipeUp))
        let directionU = UISwipeGestureRecognizerDirection.up
        swipeUp.direction = directionU
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(getter: GameScene.swipeDown))
        let directionD = UISwipeGestureRecognizerDirection.down
        swipeDown.direction = directionD
        view.addGestureRecognizer(swipeDown)
   */
        died = false
        self.physicsBody = SKPhysicsBody.init(edgeLoopFrom:CGRect(x: self.frame.origin.x,y: self.frame.origin.y + 100,width: self.frame.width, height: self.frame.height - 100))
        self.physicsWorld.gravity=CGVector(dx: 0, dy: 0);
        self.physicsBody?.categoryBitMask = wallCat
        self.physicsWorld.contactDelegate = self
        self.setupWalls()
        self.setupship()
        self.generateEmitter()
        //self.generateStars()
        enemyController = WVEnemyController.init()
        enemyController.setupEnemiesInNode(node: worldNode,frame: self.frame)
        enemyController.startTimerForEnemies()
        

        /*
        let backgroundMusic = SKAudioNode(fileNamed: "47627_2518-lq.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
       */
    }

    
    func setupship (){
        ship = SKSpriteNode(imageNamed: "Spaceship")
        ship.name = "ship"
        ship.xScale = 0.5;
        ship.yScale = 0.5
        ship.zPosition = 2;
        ship.zRotation = CGFloat(-M_PI/2)  // ship rotated pointing right
        ship.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2) //ship in middel of screen
        
        //ship.physicsBody=SKPhysicsBody.init(rectangleOf:ship.size); //vierkantje om schip
        // Spaceship: physics body using texture’s alpha channel
        let shipTexture = SKTexture(imageNamed: "Spaceship")
        ship.physicsBody = SKPhysicsBody(texture: shipTexture, alphaThreshold: 0.9, size: CGSize(width: ship.size.width, height: ship.size.height))

        ship.physicsBody?.isDynamic = true
        ship.physicsBody?.contactTestBitMask = wallCat
        ship.physicsBody?.collisionBitMask = 0xffffffff; //wit
        ship.physicsBody?.usesPreciseCollisionDetection = true
        ship.physicsBody?.categoryBitMask = playerCat
        ship.physicsBody?.density = 1.5
        ship.physicsBody?.allowsRotation = false;
        worldNode.addChild(ship)
    }
    

    func xImpulse()->CGFloat {
        return 200.0
    }
    
    func setupWalls () {
        worldNode = SKNode.init()
        worldNode.position = self.frame.origin
        worldNode.zPosition = 1;
        
        topBlock = SKNode.init()
        //topBlock.physicsBody = SKPhysicsBody.init(edgeLoopFrom:CGRect(x: self.frame.origin.x, y: self.frame.maxY - 1920, width: self.frame.width, height: 1180))  //was maxY - 300 and hight: 10
        
        topBlock.physicsBody = SKPhysicsBody.init(edgeLoopFrom:CGRect(x: self.frame.origin.x + 300, y: self.frame.maxY - 300, width: self.frame.width - 300, height: 300))  //

        topBlock.physicsBody?.categoryBitMask = wallCat
        topBlock.zPosition = 2
        
        
        worldNode.addChild(topBlock)
        self.addChild(worldNode)
    }
    
    // Persist the initial touch position of the remote
    var touchPositionX: CGFloat = 0.0
    var touchPositionY: CGFloat = 0.0
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: worldNode)
            
            if touchPositionX != 0.0 && touchPositionY != 0.0 {
                
                // Calculate the movement on the remote
                let deltaX = (touchPositionX - location.x)
                let deltaY = (touchPositionY - location.y)
                
                // Calculate the new Sprite position
                var x = ship.position.x - deltaX
                var y = ship.position.y - deltaY
                
                // Check if the sprite will leave the screen
                if x < 0 {
                    x = 0
                } else if x > self.frame.width {
                    x = self.frame.width
                }
                if y < 0 {
                    y = 0
                } else if y > self.frame.height {
                    y = self.frame.height
                }
                
                // Move the sprite
                ship.position = CGPoint(x: x, y: y)
                
            }
            // Persist latest touch position
            touchPositionY = location.y
            touchPositionX = location.x
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchPositionX = touch.location(in: worldNode).x
            touchPositionY = touch.location(in: worldNode).y
        }
        
        if died {
            self.removeAllChildren()
            self.didMove(to: self.view!)
            worldNode.speed = 1
            playAgain.removeFromParent()
        }
        
    }
    

    
    //voor de bewegende achtergrond met sterren
    private let platformParent = SKNode()
    func initializingScrollingBackground() {
            self.addChild(platformParent)
        for index in 0 ..< 2 + 1  {
        //for index in 0..<2 {
            let bg = SKSpriteNode(imageNamed: "fond-space-stars-only")
            bg.position = CGPoint(x:index * (Int(bg.size.width)+1), y: 0)
            bg.anchorPoint = CGPoint.zero
            bg.name = "background"
            self.addChild(bg)
        }
    }
    
    //bewegende achtergrond
    func moveBackground() {
        self.enumerateChildNodes(withName: "background", using: { (node, stop) -> Void in
            if let bg = node as? SKSpriteNode {
                bg.position = CGPoint(x: bg.position.x - self.backgroundVelocity, y: bg.position.y)
                // Checks if bg node is completely scrolled off the screen, if yes, then puts it at the end of the other node.
                if bg.position.x <= -bg.size.width {
                    bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                }
            }
        })
    }

    func generateExplosion() {
        explosionSprite = SKEmitterNode(fileNamed: "Explosion.sks")!
        explosionSprite.position = ship.position
        explosionSprite.zPosition = 3
        worldNode.addChild(explosionSprite)
        let delay = SKAction.wait(forDuration: 0.4)
        explosionSprite.run(delay) { () -> Void in
        }
    }
    
    func generateEmitter () {
        emissionSprite = SKEmitterNode(fileNamed: "trailEmitter.sks")!
        emissionSprite.position = ship.position
        emissionSprite.zPosition = 2
        emissionSprite.zRotation = CGFloat(-M_PI/2)  //facing right
        worldNode.addChild(emissionSprite)
    }
/*
    func generateStars () {
        //extra sterren
        stars = SKEmitterNode(fileNamed: "stars.sks")!
        stars.position = CGPoint(x: self.frame.midX,y: self.frame.maxY)
        //stars.particlePositionRange = CGVector(dx: self.frame.size.width, dy:5)
        stars.particlePositionRange = CGVector(dx: self.frame.midX , dy:5)
        stars.zPosition = 2
        stars.speed = 1.0
        worldNode.addChild(stars)
    }
  */
    
    func playSound() {
        guard let sound = NSDataAsset(name: "explosion") else {
            print("asset not found")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            playExplosion = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            playExplosion!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == playerCat && contact.bodyB.categoryBitMask == 0x1 << 0) || (contact.bodyA.categoryBitMask == 0x1 << 0 && contact.bodyB.categoryBitMask == playerCat) {
            died = true
            playSound() //explosion
            worldNode.speed = 0  //if 0 the rocks stop at game over
            //stars.isPaused = true
            ship.removeAllActions()
            generateExplosion()
            self.ship.removeFromParent()
            emissionSprite.removeFromParent()
            self.removeAction(forKey: "enemy")
            playAgain = SKLabelNode.init(text: "Tap to play again")
            playAgain.fontSize = 30
            playAgain.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            playAgain.zPosition = 4
            worldNode.addChild(playAgain)
        }

     }

    
    override func update(_ currentTime: TimeInterval) {
 
        //let moveX:SKAction = SKAction.moveTo(x: ship.position.x - (ship.size.height - 20), duration: 0)
        let moveX:SKAction = SKAction.moveTo(x: ship.position.x - (ship.size.height - 40), duration: 0)

        let moveY:SKAction = SKAction.moveTo(y: ship.position.y, duration: 0)
        let totalActions:SKAction = SKAction.sequence([moveX,moveY])
        emissionSprite.run(totalActions)

        self.moveBackground()
    }

}

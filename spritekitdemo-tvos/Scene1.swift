//
//  Scene1.swift
//  spritekitdemo-tvos
//
//  Created by Razvan on 22/05/2016.
//  Copyright © 2016 Razvan Bunea. All rights reserved.
//

import SpriteKit

class Scene1: SKScene {
    let myCamera = SKCameraNode()
    var maxX:CGFloat = 0
    let ship = SKSpriteNode(imageNamed:"Spaceship")
    var bgArray = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        //creation des 3 fonds d'ecran pour simuler le deplacement (positionnés un après l'autre
        let background1 = SKSpriteNode(imageNamed: "space-stars")
        background1.name = "BG1"
        background1.position  = CGPoint(x:self.frame.width/2 + (background1.frame.width - self.frame.width)/2, y:self.frame.height/2)
        bgArray.append(background1)
        
        let background2 = SKSpriteNode(imageNamed: "space-stars")
        background2.name = "BG2"
        background2.position  = CGPoint(x:background1.position.x + background1.frame.width + 200, y:self.frame.height/2)
        bgArray.append(background2)
        
        let background3 = SKSpriteNode(imageNamed: "space-stars")
        background3.name = "BG3"
        background3.position  = CGPoint(x:background2.position.x + background2.frame.width + 200, y:self.frame.height/2)
        bgArray.append(background3)
        
        maxX = background3.position.x + background3.frame.width
        
        print("bk1: \(background1.position), bk2: \(background2.position), bk3: \(background3.position)")
        self.addChild(background1)
        self.addChild(background2)
        self.addChild(background3)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        //si le Ship n'est pas ajouté à la scene on l'ajoute
        if (self.childNode(withName: "SHIP") == nil) {
            //on le retourne car image orientée dans le mauvais sens
            ship.zRotation = CGFloat(-M_PI/2)
            ship.xScale = 0.5
            ship.yScale = 0.5
            ship.zPosition = 10
            ship.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
            ship.name = "SHIP"
        
            let action = SKAction.moveBy(x: 500, y: 0, duration: 1)
            
            //myCamera.runAction(action)
            //déplacement du vaisseau
            ship.run(SKAction.repeatForever(action))
            
            self.addChild(ship)
        }
       
        //ajout de la camera
        if (self.childNode(withName: "CAMERA") == nil) {
            myCamera.position = ship.position
            myCamera.name = "CAMERA"
            addChild(myCamera)
            //définition comme camera de la vue
            self.camera = myCamera
            
            //creation d'un contraite pour que le caméra rest liée au vaisseau
            let constraint = SKConstraint.distance(SKRange(constantValue: 0.0), to: ship)
            myCamera.constraints = [constraint]
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        //let action = SKAction.moveTo(ship.position, duration: 0.25)
        //récupération de la position du vaisseau
        let shipX = ship.position.x
        if ( shipX > 0) {
            //on vérifie que chaque image de fond n'est pas hors de l'écan
            for bg in bgArray {
                //si la position du vaisseau est après le fond on déplace le background à maxX
                if shipX > bg.position.x + bg.frame.width + ship.frame.width/2 {
                    bg.position.x = maxX
                    maxX += bg.frame.width
                    //print("Bg: \(bg.name) déplacé en: \(bg.position.x)")
                }
            }
            createAsteroid()
        }
    }
    
    
    fileprivate func createAsteroid() {
        //creation alétaroire d'astéroid
        let randomApparence = arc4random_uniform(1000)
        
        if randomApparence > 970 {
            
            let randomRadius = arc4random_uniform(50) + 50
            
            let asteroid = SKShapeNode(circleOfRadius: CGFloat(randomRadius))
            asteroid.fillColor = .lightGray
            asteroid.name  = "ASTEROID"
            asteroid.zPosition = ship.zPosition + 1
            asteroid.position.x = ship.position.x + 1000
            
            let maxHeight = self.size.height - asteroid.frame.height
            asteroid.position.y = CGFloat(arc4random_uniform(UInt32(maxHeight))) + asteroid.frame.height/2
            
            
            self.addChild(asteroid)
        }
    }
}

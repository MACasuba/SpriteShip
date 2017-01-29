//
//  GameOverScene.swift
//  spritekitdemo-tvos
//
//  Created by Razvan on 22/05/2016.
//  Copyright (c) 2016 Razvan Bunea. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation

//class GameOverScene: UIViewController {
 class GameOverScene: SKScene {

       
    
    //@IBOutlet weak var button1: UIButton!
   // @IBOutlet weak var button2: UIButton!
   // @IBOutlet weak var bigLabel: UILabel!
    
    //override func viewDidLoad() {
    //    super.viewDidLoad()
        
        override func didMove(to view: SKView) {
            /* Setup your scene here */
        
        // Do any additional setup after loading the view, typically from a nib.
        //button1.addTarget(self, action: #selector(ViewController.button1Pressed(_:)), for: .primaryActionTriggered)
       // button2.addTarget(self, action: #selector(ViewController.button2Pressed(_:)), for: .primaryActionTriggered)
        
    }

    
    func button1Pressed(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "GAME OVER", message: "Press any key to continue", preferredStyle: .alert)
        //let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { alert in
            UIView.animate(withDuration: 0.5, animations: {
                


            })
        }
        alertController.addAction(okAction)
        //present(alertController, animated: true, completion: nil)
        
    }//button1pressed
 
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        let scene = GameScene(size: size)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        self.view?.presentScene(scene, transition: reveal)
    }
 
    /*
    func button2Pressed(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Warning", message: "You’re about to turn everything purple.", preferredStyle: .alert)
        let changeAction = UIAlertAction(title: "Change to Purple", style: .destructive) { alert in
            UIView.animate(withDuration: 0.5, animations: {
                self.view.backgroundColor = UIColor.purple
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(changeAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    */
    
    /*
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.white
        
        let message = "Game over"
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(label)
        
        let replayMessage = "Replay Game"
        let replayButton = SKLabelNode(fontNamed: "Chalkduster")
        replayButton.text = replayMessage
        replayButton.fontColor = SKColor.black
        replayButton.position = CGPoint(x: self.size.width/2, y: 50)
        replayButton.name = "replay"
        self.addChild(replayButton)
    }
    */
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {

        //for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "replay" {
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }*/


}

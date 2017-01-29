//
//  GameViewController.swift
//  spritekitdemo-tvos
//
//  Created by Razvan on 22/05/2016.
//  Copyright (c) 2016 Razvan Bunea. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add label
        let myLabel : UILabel = UILabel(frame: CGRect(x: 800, y: 900, width: 800, height: 100));
        myLabel.font = UIFont(name: "Chalkduster", size: 65)
        myLabel.textColor = UIColor.white
        myLabel.adjustsFontSizeToFitWidth = true
        myLabel.text = "Hello, spaceWorld!"
        self.view?.addSubview(myLabel)

        
        if let scene = GameScene(fileNamed: "GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .aspectFill
            scene.scaleMode = .resizeFill

            skView.showsPhysics = false
            skView.presentScene(scene)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}

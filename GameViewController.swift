//
//  GameViewController.swift
//  Test
//
//  Created by Ania Bui & Hy Nguyen on 2/14/16.
//  Copyright © 2016 AHa Production. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        let scene = Menu(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

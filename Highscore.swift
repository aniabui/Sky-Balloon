//
//  EndGameScene.swift
//  Sky Balloon
//
//  Created by Ania Bui & Hy Nguyen on 3/20/16.
//  Copyright © 2016 AHa Production. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class Highscore: SKScene {
    
    let lblMenu = SKLabelNode(fontNamed: "Futura")
    var backgroundMusicPlayer = AVAudioPlayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Watermelons
        let watermelon = SKSpriteNode(imageNamed: "Watermelon")
        watermelon.position = CGPoint(x: self.size.width/2 - 48, y: self.size.height/2 + 15)
        addChild(watermelon)
        
        let lblStars = SKLabelNode(fontNamed: "Futura")
        lblStars.fontSize = 50
        lblStars.fontColor = SKColor.whiteColor()
        lblStars.position = CGPoint(x: self.size.width/2 - 22, y: self.size.height/2)
        lblStars.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblStars.text = String(format: "%d", GameState.sharedInstance.highScore)
        addChild(lblStars)
        
        // GAME OVER
        let lblGameOver = SKLabelNode(fontNamed: "Futura")
        lblGameOver.fontSize = 50
        lblGameOver.fontColor = UIColor(red: 0.9373, green: 0.2392, blue: 0.2902, alpha: 1.0)
        lblGameOver.position = CGPoint(x: self.size.width / 2, y: self.size.height - 150)
        lblGameOver.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblGameOver.text = "HIGH SCORE"
        addChild(lblGameOver)
        
        
        // Try again
        lblMenu.fontSize = 30
        lblMenu.fontColor = SKColor.whiteColor()
        lblMenu.position = CGPoint(x: self.size.width / 2, y: 100)
        lblMenu.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblMenu.text = "main menu"
        lblMenu.name = "menu"
        
        addChild(lblMenu)
        
        if GameState.sharedInstance.Sound == true {
            playBackgroundMusic("gameover.mp3")
        }
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Transition back to the Game
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            if (node.name == "menu") {
                let gameScene = Menu(size: self.size)
                let reveal = SKTransition.fadeWithDuration(0.5)
                self.scene!.view!.presentScene(gameScene, transition: reveal)
            }
        }
    }
    
    func playBackgroundMusic(filename: String) {
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
}
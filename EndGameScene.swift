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

class EndGameScene: SKScene {
    
    let lblTryAgain = SKLabelNode(fontNamed: "Futura")
    let lblMainMenu = SKLabelNode(fontNamed: "Futura")
    var backgroundMusicPlayer = AVAudioPlayer()
    
    let Logo = SKSpriteNode(imageNamed: "GameOver")

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Watermelons
        /*let watermelon = SKSpriteNode(imageNamed: "Watermelon")
        watermelon.position = CGPoint(x: self.size.width / 2, y: self.size.height/2 + 15)
        addChild(watermelon)*/
        
        let lblStars = SKLabelNode(fontNamed: "Futura")
        lblStars.fontSize = 60
        lblStars.fontColor = UIColor(red: 239/255, green: 61/255, blue: 74/255, alpha: 1.0)
        lblStars.position = CGPoint(x: self.size.width / 2, y: self.size.height/2+15)
        //lblStars.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblStars.text = String(format: "%d", GameState.sharedInstance.watermelons)
        addChild(lblStars)
        
        // GAME OVER
        /*let lblGameOver = SKLabelNode(fontNamed: "Futura")
        lblGameOver.fontSize = 50
        lblGameOver.fontColor = UIColor(red: 0.9373, green: 0.2392, blue: 0.2902, alpha: 1.0)
        lblGameOver.position = CGPoint(x: self.size.width / 2, y: self.size.height - 150)
        lblGameOver.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblGameOver.text = "GAME OVER!"
        addChild(lblGameOver)*/
        
        // High Score
        let lblHighScore = SKLabelNode(fontNamed: "Futura")
        lblHighScore.fontSize = 20
        lblHighScore.fontColor = SKColor.whiteColor()
        lblHighScore.position = CGPoint(x: self.size.width / 2, y: self.size.height/2 - 50)
        lblHighScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblHighScore.text = String(format: "High Score: %d", GameState.sharedInstance.highScore)
        addChild(lblHighScore)
        
        // Try again
        lblTryAgain.fontSize = 30
        lblTryAgain.fontColor = SKColor.whiteColor()
        lblTryAgain.position = CGPoint(x: self.size.width / 2, y: 150)
        lblTryAgain.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblTryAgain.text = "play again"
        lblTryAgain.name = "tryagain"
        
        addChild(lblTryAgain)
        
        // Main menu
        lblMainMenu.fontSize = 30
        lblMainMenu.fontColor = SKColor.whiteColor()
        lblMainMenu.position = CGPoint(x: self.size.width / 2, y: 100)
        lblMainMenu.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblMainMenu.text = "main menu"
        lblMainMenu.name = "mainmenu"
        
        addChild(lblMainMenu)
        
        
        // LOGO
        Logo.position = CGPoint(x: self.size.width / 2, y: self.size.height - 150)
        self.addChild(Logo)
        
        if GameState.sharedInstance.Sound == true {
            playBackgroundMusic("gameover.mp3")
        }
        
    }
    

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Transition back to the Game
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            if (node.name == "tryagain") {
                let gameScene = GameScene(size: self.size)
                let reveal = SKTransition.fadeWithDuration(0.5)
                self.scene!.view!.presentScene(gameScene, transition: reveal)
            }
            else if(node.name == "mainmenu") {
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
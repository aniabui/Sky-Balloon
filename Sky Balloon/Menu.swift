//
//  Menu.swift
//  Sky Balloon
//
//  Created by Ania Bui & Hy Nguyen on 2/29/16.
//  Copyright © 2016 AHa Production. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
import UIKit

class Menu: SKScene {
    //let Play = SKSpriteNode(imageNamed: "Play")
    let Play = SKShapeNode(rectOfSize: CGSize(width: 300, height: 40))
    let PlaySensor = SKShapeNode(rectOfSize: CGSize(width: 300, height: 40))
    //let Scoreboard = SKSpriteNode(imageNamed: "Scoreboard")
    let Scoreboard = SKShapeNode(rectOfSize: CGSize(width: 300, height: 40))
    let ScoreboardSensor = SKShapeNode(rectOfSize: CGSize(width: 300, height: 40))
    //let Sound = SKSpriteNode(imageNamed: "Sound")
    let Sound = SKShapeNode(rectOfSize: CGSize(width: 300, height: 40))
    let SoundSensor = SKShapeNode(rectOfSize: CGSize(width: 300, height: 40))

    let Top = SKSpriteNode(imageNamed: "Top")
    let Bottom = SKSpriteNode(imageNamed: "Bottom")
    let Title = SKSpriteNode(imageNamed: "Title")
    
    let NoSound = SKShapeNode (rectOfSize: CGSize(width: 60, height: 3))
    
    //let backgroundMusic = SKAudioNode(fileNamed: "menu.mp3")
    var backgroundMusicPlayer = AVAudioPlayer()
    
    var icon : SKSpriteNode!
    var iconFrames : [SKTexture]!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        // MUSIC
        //backgroundMusic.autoplayLooped = true
        //addChild(backgroundMusic)
        
        // TITLE
        Title.position = CGPoint(x: self.size.width / 2, y: 400)
        self.addChild(Title)
        
        // LOGO
        Top.position = CGPoint(x: self.size.width / 2, y: 480)
        self.addChild(Top)
        Bottom.position = CGPoint(x: self.size.width / 2, y: 330)
        self.addChild(Bottom)
        
        
        // PLAY
        Play.position = CGPoint(x: self.size.width / 2, y: 250)
        Play.strokeColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        Play.fillColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        Play.name = "Play"
        self.addChild(Play)
        Play.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 300, height: 40))
        Play.physicsBody?.affectedByGravity = false
        
        let PlayLabel = SKLabelNode(text: "PLAY")
        PlayLabel.position = CGPoint(x: 0, y: -7)
        PlayLabel.fontSize = 20
        PlayLabel.fontName = "Futura"
        Play.addChild(PlayLabel)
        
        PlaySensor.position = CGPoint(x: 0, y: 0)
        PlaySensor.strokeColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        PlaySensor.fillColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        PlaySensor.name = "play"
        Play.addChild(PlaySensor)
        
        // SCOREBOARD
        Scoreboard.position = CGPoint(x: self.size.width / 2, y: 200)
        Scoreboard.strokeColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        Scoreboard.fillColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        Scoreboard.name = "Scoreboard"
        self.addChild(Scoreboard)
        Scoreboard.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 300, height: 40))
        Scoreboard.physicsBody?.affectedByGravity = false
        
        let ScoreboardLabel = SKLabelNode(text: "highscore")
        ScoreboardLabel.position = CGPoint(x: 0, y: -7)
        ScoreboardLabel.fontSize = 20
        ScoreboardLabel.fontName = "Futura"
        Scoreboard.addChild(ScoreboardLabel)
        
        ScoreboardSensor.position = CGPoint(x: 0, y: 0)
        ScoreboardSensor.strokeColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        ScoreboardSensor.fillColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        ScoreboardSensor.name = "scoreboard"
        Scoreboard.addChild(ScoreboardSensor)
        
        // SOUND
        Sound.position = CGPoint(x: self.size.width / 2, y: 150)
        Sound.strokeColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        Sound.fillColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        Sound.name = "Sound"
        self.addChild(Sound)
        Sound.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 300, height: 40))
        Sound.physicsBody?.affectedByGravity = false
        
        SoundSensor.position = CGPoint(x: 0, y: 0)
        SoundSensor.strokeColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        SoundSensor.fillColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        SoundSensor.name = "sound"
        Sound.addChild(SoundSensor)
        
        NoSound.strokeColor = SKColor(white: 0, alpha: 0)
        NoSound.fillColor = SKColor(white: 1, alpha: 1)
        NoSound.position = CGPoint(x: 2, y: -2)
        
        let SoundLabel = SKLabelNode(text: "sound")
        SoundLabel.position = CGPoint(x: 0, y: -7)
        SoundLabel.fontSize = 20
        SoundLabel.fontName = "Futura"
        Sound.addChild(SoundLabel)
        
        //Sound.position = CGPoint(x: self.size.width / 2, y: 200)
        //self.addChild(Sound)
        
        if GameState.sharedInstance.Sound == true {
            playBackgroundMusic("menu.mp3")
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            // If next button is touched, start transition to second scene
            if (node.name == "play") {
                let secondScene = GameScene(size: self.size)
                let transition = SKTransition.fadeWithDuration(0.5)
                secondScene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view?.presentScene(secondScene, transition: transition)
            }
            if (node.name == "scoreboard") {
                let secondScene = Highscore(size: self.size)
                let transition = SKTransition.fadeWithDuration(0.5)
                secondScene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view?.presentScene(secondScene, transition: transition)
            }
            if node.name == "sound" {
                if GameState.sharedInstance.Sound == true {
                    GameState.sharedInstance.Sound = false
                    Sound.addChild(NoSound)
                    stopBackgroundMusic("menu.mp3")
                }
                else {
                    GameState.sharedInstance.Sound = true
                    NoSound.removeFromParent()
                    playBackgroundMusic("menu.mp3")
                }
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
    
    func stopBackgroundMusic(filename: String) {
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.pause()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
}
//
//  GameScene.swift
//  Test
//
//  Created by Ania Bui & Hy Nguyen on 2/14/16.
//  Copyright © 2016 AHa Production. All rights reserved.
//

import SpriteKit
import AVFoundation

// To Accommodate iPhone 6
var scaleFactor: CGFloat!

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    let PauseButton = SKSpriteNode(imageNamed: "PauseButton")
    var pauseScreen = SKShapeNode()    
    
    let lWall = WallNode()
    let rWall = WallNode()
    
    let vButton = SKShapeNode(circleOfRadius: 11)
    let hButton = SKShapeNode(circleOfRadius: 11)
    
    let platform = WallNode()

    var backgroundMusicPlayer = AVAudioPlayer()
    
    // Layered Nodes
    var backgroundNode: SKNode!
    var foregroundNode: SKNode!
    var hudNode: SKNode!
    var player: SKNode!
    var horizontal: SKNode! // horizontal bar (slider)
    var vertical: SKNode! // vertical bar (slider)
    
    var lblLife: SKLabelNode!
    var lblWatermelons: SKLabelNode!
    
    var scaleFactor: CGFloat!
    
    var cumulativeNumberOfTouches = 0
    
    let soundEffect = SKAudioNode(fileNamed: "balloon.wav")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //inititiate everything
    override init(size: CGSize) {
        
        
        GameState.sharedInstance.watermelons = 0
        GameState.sharedInstance.life = 0
        
        super.init(size: size)
        
        scaleFactor = self.size.width / 320.0
        backgroundNode = createBackgroundNode()
        addChild(backgroundNode)
        
        foregroundNode = SKNode()
        addChild(foregroundNode)
        
        hudNode = SKNode()
        addChild(hudNode)
        
        let levelPlist = NSBundle.mainBundle().pathForResource("Level01", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        
        horizontal = hBar()
        vertical = vBar()

        let balloons = levelData["Balloons"] as! NSDictionary
        let balloonPatterns = balloons["Patterns"] as! NSDictionary
        let balloonPositions = balloons["Positions"] as! [NSDictionary]
        
        //Lookup positions of balloon in Level01.plist
        for balloonPosition: NSDictionary in balloonPositions {
            let patternX = balloonPosition["x"]?.floatValue
            let patternY = balloonPosition["y"]?.floatValue
            let pattern = balloonPosition["pattern"] as! NSString
            
            // Look up the pattern
            let balloonPattern = balloonPatterns[pattern] as! [NSDictionary]
            for balloonPoint in balloonPattern {
                let x = balloonPoint["x"]?.floatValue
                let y = balloonPoint["y"]?.floatValue
                let type = BalloonType(rawValue: balloonPoint["type"]!.integerValue)
                let positionX = CGFloat(x! + patternX!)
                let positionY = CGFloat(y! + patternY!)
                let balloonNode = createBalloonAtPosition(CGPoint(x: positionX, y: positionY), ofType: type!)
                foregroundNode.addChild(balloonNode)
            }
        }
        
        
        // Build the HUD
        
        // Stars
        // 1
        let watermelon = SKSpriteNode(imageNamed: "SmallWatermelon")
        watermelon.position = CGPoint(x: 30, y: self.size.height-25)
        hudNode.addChild(watermelon)
        
        // 2
        lblWatermelons = SKLabelNode(fontNamed: "Futura")
        lblWatermelons.fontSize = 30
        lblWatermelons.fontColor = SKColor.whiteColor()
        lblWatermelons.position = CGPoint(x: 58, y: self.size.height-35)
        lblWatermelons.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        // 3
        lblWatermelons.text = String(format: "%d", GameState.sharedInstance.watermelons)
        hudNode.addChild(lblWatermelons)
        
        // Score
        // 4
        lblLife = SKLabelNode(fontNamed: "Futura")
        lblLife.fontSize = 30
        lblLife.fontColor = SKColor.whiteColor()
        lblLife.position = CGPoint(x: self.size.width-15, y: self.size.height-35)
        lblLife.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        
        // 5
        lblLife.text = String(format: "%d", GameState.sharedInstance.life)
        hudNode.addChild(lblLife)
        
        
        //VERTICAL BUTTON
        vButton.position = CGPoint(x: 50, y: 75)
        vButton.fillColor = UIColor(red: 0.9373, green: 0.2392, blue: 0.2902, alpha: 1.0)
        vButton.strokeColor = SKColor.redColor()
        vButton.runAction(
            SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.moveByX(0, y: 150,
                        duration: NSTimeInterval(0.25)),
                    SKAction.moveByX(0, y: -150,
                        duration: NSTimeInterval(0.25))])))
        
        //HORIZONTAL BUTTON
        hButton.position = CGPoint(x: (self.size.width / 2) + 75, y: 50)
        hButton.fillColor = UIColor(red: 0.9373, green: 0.2392, blue: 0.2902, alpha: 1.0)
        hButton.strokeColor = SKColor.redColor()
        hButton.runAction(
            SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.moveByX(-150, y: 0,
                        duration: NSTimeInterval(0.25)),
                    SKAction.moveByX(150, y: 0,
                        duration: NSTimeInterval(0.25))])))

        // PAUSE BUTTON
        PauseButton.position = CGPoint(x: self.size.width / 2, y: self.size.height - 25)
                
        // WALL
        let left = SKShapeNode(rectOfSize: CGSize(width: 1, height: 200000))
        left.fillColor = SKColor(white: 0, alpha: 0)
        left.strokeColor = SKColor(white: 0, alpha: 0)
        lWall.addChild(left)
        lWall.position = CGPoint(x:0, y:100000)
        lWall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 1, height: 200000))
        lWall.physicsBody?.dynamic = false
        lWall.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Wall
        lWall.physicsBody?.collisionBitMask = CollisionCategoryBitmask.Player
        lWall.physicsBody?.contactTestBitMask = 0
        
        let right = SKShapeNode(rectOfSize: CGSize(width: 1, height: 200000))
        right.fillColor = SKColor(white: 0, alpha: 0)
        right.strokeColor = SKColor(white: 0, alpha: 0)
        rWall.addChild(right)
        rWall.position = CGPoint(x:self.size.width, y:100000)
        rWall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 1, height: 200000))
        rWall.physicsBody?.dynamic = false
        rWall.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Wall
        rWall.physicsBody?.collisionBitMask = CollisionCategoryBitmask.Player
        rWall.physicsBody?.contactTestBitMask = 0
        
        //PLATFORM
        let shape = SKShapeNode(rectOfSize: CGSize(width: 5, height: 1))
        shape.fillColor = SKColor(white: 0, alpha: 0)
        shape.strokeColor = SKColor(white: 0, alpha: 0)
        platform.addChild(shape)
        platform.position = CGPoint(x: self.size.width / 2, y: 115)
        platform.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 5, height: 1))
        platform.physicsBody?.dynamic = false
        platform.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Wall
        platform.physicsBody?.collisionBitMask = CollisionCategoryBitmask.Player
        platform.physicsBody?.contactTestBitMask = 0
        
        //PLAYER
        player = createPlayer()
        
        foregroundNode.addChild(player)
        foregroundNode.addChild(vertical)
        foregroundNode.addChild(horizontal)
        foregroundNode.addChild(lWall)
        foregroundNode.addChild(rWall)
        foregroundNode.addChild(platform)
        
        hudNode.addChild(PauseButton)
        hudNode.addChild(hButton)
        hudNode.addChild(vButton)
        
        PauseButton.name = "pause"
        
        pauseScreen = SKShapeNode(rectOfSize: CGSize(width: self.size.width * 2, height: self.size.height * 2))
        pauseScreen.fillColor = SKColor (red: 0, green: 0, blue: 0, alpha: 0.5)
        pauseScreen.name = "pauseS"
        let lblPause = SKLabelNode(fontNamed: "Futura")
        lblPause.fontSize = 50
        lblPause.fontColor = UIColor(red: 0.9373, green: 0.2392, blue: 0.2902, alpha: 1.0)
        lblPause.position = CGPoint(x: self.size.width / 2, y: self.size.height - 150)
        lblPause.text = "PAUSED"
        let lblCont = SKLabelNode(fontNamed: "Futura")
        lblCont.fontSize = 30
        lblCont.fontColor = UIColor(white: 1, alpha: 1)
        lblCont.position = CGPoint(x: self.size.width / 2, y: 150)
        lblCont.text = "touch to continue"
        pauseScreen.addChild(lblPause)
        pauseScreen.addChild(lblCont)
        
        // Gravity
        physicsWorld.gravity = CGVector(dx: CGFloat(0),dy: CGFloat(-0.75))
        physicsWorld.contactDelegate = self
        
        if GameState.sharedInstance.Sound == true {
            playBackgroundMusic("game.mp3")
        }
        
        soundEffect.autoplayLooped = false
        addChild(soundEffect)
        
    }
    
    
    //didBeginContact(): when there is contact, update HUD with scores and life
    func didBeginContact(contact: SKPhysicsContact) {
        // 1
        var updateHUD = false
        
        // 2
        let whichNode = (contact.bodyA.node != player) ? contact.bodyA.node : contact.bodyB.node
        let other = whichNode as! GameObjectNode
        
        // 3
        updateHUD = other.collisionWithPlayer(player)
        
        // Update the HUD if necessary
        if updateHUD {
            lblWatermelons.text = String(format: "%d", GameState.sharedInstance.watermelons)
            lblLife.text = String(format: "%d", GameState.sharedInstance.life)
            if GameState.sharedInstance.Sound == true {
                runAction(SKAction.playSoundFileNamed("balloon.wav", waitForCompletion: false))
            }
        }
    }
    
    //createBackgroundNode(): create and loop background 20x
    func createBackgroundNode() -> SKNode {
        // Create the node
        let backgroundNode = SKNode()
        let ySpacing = 568.0 * scaleFactor
        
        // 2
        // Go through images until the entire background is built
        for index in 0...19 {
            // 3
            let node = SKSpriteNode(imageNamed:"BackgroundImage")
            // 4
            node.setScale(scaleFactor)
            node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            node.position = CGPoint(x: self.size.width / 2, y: ySpacing * CGFloat(index))
            //5
            backgroundNode.addChild(node)
        }
        
        // 6
        // Return the completed background node
        return backgroundNode
    }
    
    //createPlayer(): create the main character
    func createPlayer() -> SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width / 2, y: 150.0)
        
        let sprite = SKSpriteNode(imageNamed: "Hedgehog")
        playerNode.addChild(sprite)
        
        // 1
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        // 3
        playerNode.physicsBody?.allowsRotation = false
        // 4
        playerNode.physicsBody?.restitution = 0.75
        playerNode.physicsBody?.friction = 0.0
        playerNode.physicsBody?.angularDamping = 0.0
        playerNode.physicsBody?.linearDamping = 0.0
        
        // 1
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        // 2
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Player
        // 3
        playerNode.physicsBody?.collisionBitMask = CollisionCategoryBitmask.Wall
        // 4
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryBitmask.Watermelon | CollisionCategoryBitmask.Balloon
        playerNode.name = "hedgehog"
        
        return playerNode
    }
    
    //horizontal sliders
    func hBar() -> SKNode {
        let hBar = SKNode()
        hBar.position = CGPoint(x: self.size.width / 2, y: 50)
        
        let Bar = SKShapeNode(rectOfSize: CGSize(width: 150, height: 7),cornerRadius: 5)
        Bar.fillColor = SKColor.whiteColor()
        hBar.addChild(Bar)
        
        return hBar
    }
    
    //vertical sliders
    func vBar() -> SKNode {
        let vBar = SKNode()
        vBar.position = CGPoint(x: 50, y: 150)
        
        let Bar = SKShapeNode(rectOfSize: CGSize(width: 7, height: 150),cornerRadius: 5)
        Bar.fillColor = SKColor.whiteColor()
        vBar.addChild(Bar)
        
        return vBar
    }
    
    //createBalloonAtPosition() take in position and create balloon on the screen
    func createBalloonAtPosition(position: CGPoint, ofType type: BalloonType) -> BalloonNode {
        // 1
        let node = BalloonNode()
        let thePosition = CGPoint(x: position.x * scaleFactor, y: position.y)
        node.position = thePosition
        node.name = "NODE_BALLOON"
        node.balloonType = type
        
        // 2
        var sprite: SKSpriteNode
        if type == .Break {
            sprite = SKSpriteNode(imageNamed: "Balloon")
        } else {
            sprite = SKSpriteNode(imageNamed: "Balloon")
        }
        node.addChild(sprite)
        
        // 3
        node.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(20))
        node.physicsBody?.dynamic = false
        node.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Balloon
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }
    
    var power = CGFloat(0)
    var angle = CGFloat(0)
    
    func pauseGame()
    {
        scene?.view?.paused = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        // Remove the Tap to Start node
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            if (node.name == "pause"){
                PauseButton.removeFromParent()
                hudNode.addChild(pauseScreen)
                self.runAction(SKAction.runBlock(self.pauseGame))
            }
            if (node.name == "pauseS"){
                pauseScreen.removeFromParent()
                hudNode.addChild(PauseButton)
                self.view?.paused = false
            }
            else {
                cumulativeNumberOfTouches += 1
                switch cumulativeNumberOfTouches {
                case 1:
                    hButton.removeAllActions()
                    angle = (hButton.position.x - (self.size.width/2))
                case 2:
                    vButton.removeAllActions()
                    power = (vButton.position.y - 75) * 4
                    hButton.removeFromParent()
                    vButton.removeFromParent()
                    player.physicsBody?.applyImpulse(CGVectorMake(angle, power))
                default:
                    print("yay, it works!")
                }
            }
        }

    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //Create parallax effect of background and foreground
        if player.position.y > 200.0 {
            backgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 400.0)/10))
            foregroundNode.position = CGPoint(x: 0.0, y: -(player.position.y - 400.0))
        }
        
        if((player.position.y > 500.0) && (player.physicsBody?.velocity.dy < 0.0)) {
            GameState.sharedInstance.maxX = player.position.x
            GameState.sharedInstance.maxY = player.position.y
            print(player.position.y)
            let secondScene = GameScene2(size: self.size)
            /*let transition = SKTransition.flipVerticalWithDuration(1.0)
            secondScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(secondScene, transition: transition)*/
            
            let transition = SKTransition.moveInWithDirection(.Right, duration: 0.05)
            self.view?.presentScene(secondScene, transition: transition)
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

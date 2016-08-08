//
//  GameScene.swift
//  Test
//
//  Created by Ania Bui & Hy Nguyen on 2/14/16.
//  Copyright © 2016 AHa Production. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene2: SKScene, SKPhysicsContactDelegate{
    
    
    let PauseButton = SKSpriteNode(imageNamed: "PauseButton")
    
    let lBox = SKShapeNode(rectOfSize: CGSize(width: 180, height: 500))
    let rBox = SKShapeNode(rectOfSize: CGSize(width: 180, height: 500))
    
    var pauseScreen = SKShapeNode()
    var backgroundMusicPlayer = AVAudioPlayer()
    
    let lWall = WallNode()
    let rWall = WallNode()
    
    // Layered Nodes
    var backgroundNode: SKNode!
    var foregroundNode: SKNode!
    var hudNode: SKNode!
    var player: SKNode!
    
    var lblLife: SKLabelNode!
    var lblWatermelons: SKLabelNode!
    
    var scaleFactor: CGFloat!
    
    var gameOver = false
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        gameOver = false
        
        scaleFactor = self.size.width / 320.0
        backgroundNode = createBackgroundNode()
        addChild(backgroundNode)
        
        foregroundNode = SKNode()
        addChild(foregroundNode)
        
        hudNode = SKNode()
        addChild(hudNode)
        
        let levelPlist = NSBundle.mainBundle().pathForResource("Level01", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        
        let watermelons = levelData["Watermelons"] as! NSDictionary
        let watermelonPatterns = watermelons["Patterns"] as! NSDictionary
        let watermelonPositions = watermelons["Positions"] as! [NSDictionary]
        
        for watermelonPosition in watermelonPositions {
            let patternX = watermelonPosition["x"]?.floatValue
            let patternY = watermelonPosition["y"]?.floatValue
            let pattern = watermelonPosition["pattern"] as! NSString
            
            // Look up the pattern
            let watermelonPattern = watermelonPatterns[pattern] as! [NSDictionary]
            for watermelonPoint in watermelonPattern {
                let x = watermelonPoint["x"]?.floatValue
                let y = watermelonPoint["y"]?.floatValue
                let type = WatermelonType(rawValue: watermelonPoint["type"]!.integerValue)
                let positionX = CGFloat(x! + patternX!)
                let positionY = CGFloat(y! + patternY!)
                let WatermelonNode = createWatermelonAtPosition(CGPoint(x: positionX, y: positionY), ofType: type!)
                foregroundNode.addChild(WatermelonNode)
            }
        }
        
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
        lWall.physicsBody?.restitution = 0.75
        lWall.physicsBody?.friction = 0.0
        lWall.physicsBody?.angularDamping = 0.0
        lWall.physicsBody?.linearDamping = 0.0
        
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
        rWall.physicsBody?.restitution = 0.75
        rWall.physicsBody?.friction = 0.0
        rWall.physicsBody?.angularDamping = 0.0
        rWall.physicsBody?.linearDamping = 0.0
        
        foregroundNode.addChild(lWall)
        foregroundNode.addChild(rWall)

        
        
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
    
        
        // PAUSE BUTTON
        PauseButton.position = CGPoint(x: self.size.width / 2, y: self.size.height - 25)
        PauseButton.name = "pause"
        
        // CONTROL BOXES
        lBox.position = CGPoint(x:self.size.width/4, y:self.size.height/5)
        lBox.strokeColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        lBox.name = "left"
        
        rBox.position = CGPoint(x:self.size.width/4*3, y:self.size.height/5)
        rBox.strokeColor = SKColor(white: CGFloat(0), alpha: CGFloat(0))
        rBox.name = "right"
        
        player = createPlayer()
        
        foregroundNode.addChild(player)
        
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
        lblCont.name = "continue"
        pauseScreen.addChild(lblPause)
        pauseScreen.addChild(lblCont)
        
        
        hudNode.addChild(lBox)
        hudNode.addChild(rBox)
        hudNode.addChild(PauseButton)
        
        
        // Gravity
        physicsWorld.gravity = CGVector(dx: CGFloat(0),dy: CGFloat(-0.2))
        physicsWorld.contactDelegate = self
        
        if GameState.sharedInstance.Sound == true {
            playBackgroundMusic("game2.mp3")
        }

    }
    

    
    //Update HUD if contact
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

        }
    }
    
    //Background
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
    
    //create player
    func createPlayer() -> SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: GameState.sharedInstance.maxX, y: GameState.sharedInstance.maxY)
        
        let sprite = SKSpriteNode(imageNamed: "Hedgehog")
        playerNode.addChild(sprite)
        
        // 1
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        // 3
        playerNode.physicsBody?.allowsRotation = false
        // 4
        
        // 1
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        // 2
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Player
        // 3
        playerNode.physicsBody?.collisionBitMask = 0
        // 4
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryBitmask.Watermelon | CollisionCategoryBitmask.Owl
        playerNode.name = "hedgehog"
        
        //5 
        playerNode.physicsBody?.collisionBitMask = CollisionCategoryBitmask.Wall

        return playerNode
    }
    
    //create watermelon in places
    func createWatermelonAtPosition(position: CGPoint, ofType type: WatermelonType) -> WatermelonNode {
        // 1
        let node = WatermelonNode()
        let thePosition = CGPoint(x: position.x * scaleFactor, y: position.y)
        node.position = thePosition
        node.name = "NODE_watermelon"
        
        // 2
        node.watermelonType = type
        var sprite: SKSpriteNode
        if type == .Special {
            sprite = SKSpriteNode(imageNamed: "Watermelon")
        } else {
            sprite = SKSpriteNode(imageNamed: "Watermelon")
        }
        node.addChild(sprite)
        
        // 3
        node.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        
        // 4
        node.physicsBody?.dynamic = false
        node.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Watermelon
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = 0
        
        return node
    }
    
    
    
    //spawn enemies at random
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func spawnEnemy() {
        let enemy = OwlNode()
        let sprite = SKSpriteNode(imageNamed: "Owl")
        enemy.addChild(sprite)
        enemy.name = "NODE_owl"
        enemy.position = CGPoint(x: frame.size.width, y: player.position.y - 400)
        enemy.runAction(
            SKAction.moveByX(-size.width - 40, y: 30,
                duration: NSTimeInterval(random(2, max: 3))))
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        enemy.physicsBody?.dynamic = false
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Owl
        enemy.physicsBody?.contactTestBitMask = CollisionCategoryBitmask.Player
        enemy.physicsBody?.collisionBitMask = 0
        foregroundNode.addChild(enemy)
    }
    
    func spawnEnemy1() {
        let enemy = OwlNode()
        let sprite = SKSpriteNode(imageNamed: "Fox")
        enemy.addChild(sprite)
        enemy.name = "NODE_fox"
        enemy.position = CGPoint(x: frame.size.width * random(0, max: 1), y: player.position.y - 500)
        enemy.runAction(
            SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.rotateByAngle(0.1, duration:0.5),
                    SKAction.rotateByAngle(-0.1, duration:0.5)])))
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        enemy.physicsBody?.dynamic = false
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Owl
        enemy.physicsBody?.contactTestBitMask = CollisionCategoryBitmask.Player
        enemy.physicsBody?.collisionBitMask = 0
        foregroundNode.addChild(enemy)
    }
    
    func endGame() {
        // 1
        gameOver = true
        
        // 2
        // Save stars and high score
        GameState.sharedInstance.saveState()
        
        // 3
        let reveal = SKTransition.fadeWithDuration(0.5)
        let endGameScene = EndGameScene(size: self.size)
        self.view!.presentScene(endGameScene, transition: reveal)
        stopBackgroundMusic("game2.mp3")
    }
    
    
    override func didMoveToView(view: SKView) {
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(spawnEnemy),
                SKAction.waitForDuration(NSTimeInterval(random(2, max: 5))),
                SKAction.runBlock(spawnEnemy1),
                SKAction.waitForDuration(NSTimeInterval(random(2, max: 5)))
                ])))
    }
    
    func pauseGame()
    {
        scene?.view?.paused = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //touch left to go left, right to go right
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
            if (node.name == "left"){
                player.physicsBody?.applyImpulse(CGVectorMake(CGFloat(-10), CGFloat(0)))
            }
            if (node.name == "right"){
                player.physicsBody?.applyImpulse(CGVectorMake(CGFloat(10), CGFloat(0)))
            }
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if player.position.y > 200.0 {
            backgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 400.0)/10))
            foregroundNode.position = CGPoint(x: 0.0, y: -(player.position.y - 400.0))
        }
        
        if (GameState.sharedInstance.life == -1) {
            endGame()
        }
        
        if player.position.y < 20.0 {
            endGame()
        }
        
        if gameOver {
            return
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

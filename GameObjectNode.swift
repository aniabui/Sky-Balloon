//
//  GameObjectNode.swift
//  Sky Balloon
//
//  Created by Ania Bui & Hy Nguyen on 2/29/16.
//  Copyright © 2016 AHa Production. All rights reserved.
//

import SpriteKit
import AVFoundation



struct CollisionCategoryBitmask {
    static let Player: UInt32 = 0x00
    static let Watermelon: UInt32 = 0x01
    static let Balloon: UInt32 = 0x02
    static let Owl: UInt32 = 0x03
    static let Wall: UInt32 = 0x04
}

enum BalloonType: Int {
    case Normal = 0
    case Break
}

enum WatermelonType: Int {
    case Normal = 0
    case Special
}


class GameObjectNode: SKNode {
    
    func collisionWithPlayer(player: SKNode) -> Bool {
        return false
    }
    
    func checkNodeRemoval(playerY: CGFloat) {
        if playerY > self.position.y + 300.0 {
            self.removeFromParent()
        }
    }
}

class BalloonNode: GameObjectNode {
    var balloonType: BalloonType!
    
    //remove from screen and add score if collide with balloon
    override func collisionWithPlayer(player: SKNode) -> Bool {
        self.removeFromParent()
        // 4
        GameState.sharedInstance.life += 1
        return true
    }
}

class WatermelonNode: GameObjectNode {
    
    let soundEffect = SKAction.playSoundFileNamed("watermelon.wav", waitForCompletion: false)
    
    var watermelonType: WatermelonType!
    //remove from screen and add score if collide with watermelon    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        if GameState.sharedInstance.Sound == true {
            runAction(soundEffect, completion:  {
                self.removeFromParent()
            })
        }
        else {
            self.removeFromParent()
        }
        
        // Award Watermelons
        GameState.sharedInstance.watermelons += 1
        
        // The HUD needs updating to show the new Watermelons and score
        return true
    }
}

class OwlNode: GameObjectNode {
    let soundEffect2 = SKAction.playSoundFileNamed("fail.wav", waitForCompletion: false)
    //remove from screen and add score if collide with watermelon
    override func collisionWithPlayer(player: SKNode) -> Bool {
        if GameState.sharedInstance.Sound == true {
            runAction(soundEffect2)
        }
        
        // Award Watermelons
        GameState.sharedInstance.life -= 1
        
        // The HUD needs updating to show the new Watermelons and score
        return true
    }
}

class WallNode: GameObjectNode {
    override func collisionWithPlayer(player: SKNode) -> Bool {
        return false
    }
}


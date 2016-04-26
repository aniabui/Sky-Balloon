//
//  GameState.swift
//  Sky Balloon
//
//  Created by Ania Bui & Hy Nguyen on 2/29/16.
//  Copyright © 2016 AHa Production. All rights reserved.
//

import Foundation
import SpriteKit

class GameState {
    
    var life: Int
    var highScore: Int
    var watermelons: Int
    var maxX: CGFloat!
    var maxY: CGFloat!
    var Sound: Bool
    
    class var sharedInstance :GameState {
        struct Singleton {
            static let instance = GameState()
        }
        
        return Singleton.instance
    }
    
    //initialize state
    init() {
        // Init
        life = 0
        highScore = 0
        watermelons = 0
        maxX = 0
        maxY = 0
        Sound = true
        
        // Load game state
        let defaults = NSUserDefaults.standardUserDefaults()
        
        highScore = defaults.integerForKey("highScore")
        watermelons = defaults.integerForKey("watermelons")
    }
    
    func saveState() {
        // Update highScore if the current score is greater
        highScore = max(watermelons, highScore)
        
        // Store in user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(highScore, forKey: "highScore")
        defaults.setInteger(watermelons, forKey: "watermelons")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
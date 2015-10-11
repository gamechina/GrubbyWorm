//
//  TriggerSpriteComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/7.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit
import SpriteKit

class TriggerSpriteComponent: GKComponent {
    
    var root: SKNode

    override init() {
        root = SKNode()
        
        let size = CGSizeMake(36, 36)
//        let display = SKSpriteNode(color: Theme.temp_color, size: size)
        let display = SKSpriteNode(imageNamed: "sugar")
        display.size = size
        
        let action = SKAction.rotateByAngle(10, duration: 5)
        display.runAction(SKAction.repeatActionForever(action))
        
        root.addChild(display)
        
        super.init()
    }
}

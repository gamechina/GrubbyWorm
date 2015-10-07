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
        let display = SKSpriteNode(color: Theme.temp_color, size: size)
        
        root.addChild(display)
        
        super.init()
    }
}

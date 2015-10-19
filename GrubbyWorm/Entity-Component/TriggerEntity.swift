//
//  Trigger.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/4.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class TriggerEntity : Entity {
    
    var location: Location
    var born: Bool
    
    var energy: Int = 0
    
    init(location: Location) {
        self.location = location
        self.born = false
        
        super.init()
    }
    
    func fired() {
        if let display = componentForClass(TriggerSpriteComponent) {
            display.root.removeFromParent()
        }
    }
    
    func type() -> TriggerType {
        if let type = componentForClass(TriggerSpriteComponent)?.type {
            return type
        }
        
        return TriggerType.Sugar
    }
}

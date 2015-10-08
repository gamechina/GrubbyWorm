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
    
    init(location: Location) {
        self.location = location
        
        super.init()
    }
    
    func fired() {
        if let display = componentForClass(TriggerSpriteComponent) {
            display.root.removeFromParent()
        }
    }
}

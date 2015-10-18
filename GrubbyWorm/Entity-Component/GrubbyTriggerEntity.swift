//
//  GrubbyTriggerEntity.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/12.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class GrubbyTriggerEntity: TriggerEntity {
    
    override init(location: Location) {
        super.init(location: location)
        
        born = true
        
        let display = TriggerSpriteComponent(type: .Grubby)
        addComponent(display)
    }
    
    override func fired() {
        super.fired()
    }
}

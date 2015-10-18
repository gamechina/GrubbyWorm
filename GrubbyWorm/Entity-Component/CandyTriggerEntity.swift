//
//  CandyTriggerEntity.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/12.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class CandyTriggerEntity: TriggerEntity {
    
    override init(location: Location) {
        super.init(location: location)
        
        energy = 50
        
        let display = TriggerSpriteComponent(type: .Candy)
        addComponent(display)
    }
    
    override func fired() {
        super.fired()
    }
}


//
//  Worm.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/7.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit
import SpriteKit

class WormEntity : Entity {
    
    var info: WormInfo
    var direction: Direction
    
    override init() {
        info = WormInfo(name: "Grubby Worm", speed: 0.25, foot: 5, type: .Grubby)
        direction = .Right
        
        super.init()
    }

    func fireTrigger(trigger: TriggerEntity) {
        if let control = componentForClass(WormControlComponent) {
            let ui = control._ui
            let spriteComponent = ui?.componentForClass(UISpriteComponent)
            let score = Int((spriteComponent?.score.text)!)
            spriteComponent?.score.text = String(score! + 1)
            
            if(spriteComponent?.score.frame.size.width >= (Theme.energy_bar_margin - 10)) {
                spriteComponent?.score.fontSize--
            }
        }
    }
}

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
    
    weak var ui: UIEntity?
    
    var info: WormInfo
    
    var willCombo = false
    
    var comboCount = 0
    
    init(ui: UIEntity?) {
        self.ui = ui
        
        info = WormInfo(name: "Grubby Worm", speed: 0.45, foot: 5, type: .Grubby)
        
        super.init()
    }

    func fireTrigger(trigger: TriggerEntity) {
        if willCombo {
            if let uiSprite = ui?.componentForClass(UISpriteComponent) {
                uiSprite.moodBar.percent = 100
                uiSprite.moodBar.comboCount = comboCount
            }
            comboCount++
        } else {
            willCombo = true
        }
        
        if let control = componentForClass(WormControlComponent) {
            let ui = control._ui
            let spriteComponent = ui?.componentForClass(UISpriteComponent)
            let score = Int((spriteComponent?.score.text)!)
            
            let addScore = comboCount == 0 ? 1 : comboCount
            spriteComponent?.score.text = String(score! + addScore)
            
            if(spriteComponent?.score.frame.size.width >= (Theme.energy_bar_margin - 10)) {
                spriteComponent?.score.fontSize--
            }
        }
        
        if info.speed >= 0.1 {
            info.speed -= 0.02
        }
    }
    
    func comboFail() {
        print("combo fail.")
        willCombo = false
        comboCount = 0
    }
}

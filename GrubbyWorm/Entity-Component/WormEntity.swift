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
    
    weak var game: Game?
    
    weak var ui: UIEntity?
    
    var info: WormInfo
    
    var willCombo = false
    
    var comboCount = 0
    
    init(game: Game?, ui: UIEntity?) {
        self.game = game
        self.ui = ui
        
        info = WormInfo(name: "Grubby Worm", speed: 0.35, foot: 5, type: .Grubby)
        
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
        
        let addScore = (comboCount == 0 ? 1 : comboCount)
        game?.score += addScore
        
        if info.speed >= 0.12 {
            info.speed -= 0.01
        }
    }
    
    func comboFail() {
        print("combo fail.")
        
        willCombo = false
        comboCount = 0
    }
    
    func crazy() {
        if let controlComponent = componentForClass(WormControlComponent) {
            controlComponent.stateMachine?.enterState(WormCrazyState)
        }
    }
}

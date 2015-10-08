//
//  PlayingState.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/16.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit
import SpriteKit

class UIPlayingState: UIState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        if previousState != self {
            let spriteComponent = ui?.componentForClass(UISpriteComponent)
            spriteComponent?.usePlayingAppearance()
            
            let controlComponent = ui?.componentForClass(UIControlComponent)
            if controlComponent?.stateMachine?.stateForClass(UITitleState) == previousState {
                game?.startGame()
            } else {
                game?.resumeGame()
            }
        }
        
        super.didEnterWithPreviousState(previousState)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        let spriteComponent = ui?.componentForClass(UISpriteComponent)
        spriteComponent?.moodBar.percent -= CGFloat(seconds) * (100 / 6)
        spriteComponent?.energyBar.percent += CGFloat(seconds) * (100 / 10)
        let score = Int((spriteComponent?.score.text)!)
        spriteComponent?.score.text = String(score! + 1)
        
        if(spriteComponent?.score.frame.size.width >= (Theme.energy_bar_margin - 10)) {
            spriteComponent?.score.fontSize--
        }
        
        super.updateWithDeltaTime(seconds)
    }
}

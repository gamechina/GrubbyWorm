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
            game?.stopGyroUpdate()
            
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
        
        // moodbar progress
        if spriteComponent?.moodBar.percent != 0 {
            spriteComponent?.moodBar.percent -= CGFloat(seconds) * (100 / 6)
        }

        if spriteComponent!.energyBar.dropping {
            spriteComponent?.energyBar.percent -= CGFloat(seconds) * (100 / 10)
        }
        
        if game?.locationRandomSplit < 0 {
            game?.locationRandomSplit = 0.5
            game?.addRandomTrigger()
        } else {
            game?.locationRandomSplit -= seconds
        }
        
        super.updateWithDeltaTime(seconds)
    }
}

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
            
            game?.startGame()
        }
        
        // test
        let spriteComponent = ui?.componentForClass(UISpriteComponent)
        spriteComponent?.moodBar.percent = 100
        
        super.didEnterWithPreviousState(previousState)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        let spriteComponent = ui?.componentForClass(UISpriteComponent)
        spriteComponent?.moodBar.percent -= CGFloat(seconds) * (100 / 5)
        
        super.updateWithDeltaTime(seconds)
    }
}

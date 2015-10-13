//
//  PauseState.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/16.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class UIPauseState: UIState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        if previousState != self {
            let spriteComponent = ui?.componentForClass(UISpriteComponent)
            spriteComponent?.usePauseAppearance()
            
            game?.reportScore()
            game?.stopRecord()
        }
        
        super.didEnterWithPreviousState(previousState)
    }
}

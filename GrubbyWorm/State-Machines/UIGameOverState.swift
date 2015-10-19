//
//  GameOverState.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/16.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class UIGameOverState: UIState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        
        if previousState != self {
            let spriteComponent = ui?.componentForClass(UISpriteComponent)
            spriteComponent?.useGameOverAppearance()
            
            game?.reportScore()
            game?.stopRecord()
        }
    }
}

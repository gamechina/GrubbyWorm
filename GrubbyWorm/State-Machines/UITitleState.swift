//
//  TitleState.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/16.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit
import GameplayKit

class UITitleState: UIState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        let spriteComponent = ui?.componentForClass(UISpriteComponent)
        spriteComponent?.usePlayingAppearance()
        
        game?.startGame()
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
}

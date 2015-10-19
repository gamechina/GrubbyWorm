//
//  WormHappyState.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/16.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class WormHappyState: WormState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        
        if previousState == stateMachine?.stateForClass(WormDefeatedState) {
            worm?.info.alive = true
        }
        
        if previousState != self {
            
            if let wormSprite = worm?.componentForClass(WormSpriteComponent) {
                wormSprite.useNormalAppearance()
            }
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
}

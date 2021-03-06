//
//  WormCrazyState.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/16.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class WormCrazyState: WormState {

    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        
        if previousState != self {
            
            if let wormSprite = worm?.componentForClass(WormSpriteComponent) {
                wormSprite.useCrazyAppearance()
            }
        }
    }
}

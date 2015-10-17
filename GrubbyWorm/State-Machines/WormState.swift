//
//  WormState.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/16.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class WormState: GKState {

    weak var game: Game?
    weak var worm: WormEntity?
    
    init(game: Game?, worm: WormEntity?) {
        self.game = game
        self.worm = worm
        
        super.init()
    }
}

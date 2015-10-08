//
//  BaseState.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/16.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class UIState: GKState {
    
    var game: Game?
    var ui: UIEntity?
    
    init(game: Game?, ui: UIEntity?) {
        self.game = game
        self.ui = ui
        
        super.init()
    }
}

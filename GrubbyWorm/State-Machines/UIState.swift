//
//  BaseState.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/16.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class UIState: GKState {
    
    private var _game: Game?
    private var _ui: Entity?
    
    init(game: Game?, ui: Entity?) {
        self._game = game
        self._ui = ui
        
        super.init()
    }
}

//
//  WormControlComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/7.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class WormControlComponent: GKComponent {
    
    private weak var _game: Game?
    private var _ui: Entity?
    var stateMachine: GKStateMachine?
    
    init(game: Game?, ui: Entity?) {
        self._game = game
        self._ui = ui
        
        super.init()
        
        initStates()
    }
    
    func initStates() {
        let happy = WormHappyState(game: _game, ui: _ui)
        let crazy = WormCrazyState(game: _game, ui: _ui)
        let defeated = WormDefeatedState(game: _game, ui: _ui)
        
        stateMachine = GKStateMachine(states: [happy, crazy, defeated])
        stateMachine?.enterState(WormHappyState)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        stateMachine?.updateWithDeltaTime(seconds)
    }
}

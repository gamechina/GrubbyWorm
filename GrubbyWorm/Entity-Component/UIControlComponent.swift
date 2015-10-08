//
//  GameControlComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/23.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class UIControlComponent: GKComponent {
    
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
        let title = UITitleState(game: _game, ui: _ui)
        let playing = UIPlayingState(game: _game, ui: _ui)
        let pause = UIPauseState(game: _game, ui: _ui)
        let gameOver = UIGameOverState(game: _game, ui: _ui)
        
        stateMachine = GKStateMachine(states: [title, playing, pause, gameOver])
        stateMachine?.enterState(UITitleState)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        stateMachine?.updateWithDeltaTime(seconds)
    }
}

//
//  WormControlComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/7.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class WormControlComponent: GKComponent {
    
    weak var game: Game?
    weak var worm: WormEntity?
    
    var stateMachine: GKStateMachine?
    
    init(game: Game?, worm: WormEntity?) {
        self.game = game
        self.worm = worm
        
        super.init()
        
        initStates()
    }
    
    func initStates() {
        let free = WormFreeState(game: game, worm: worm)
        let happy = WormHappyState(game: game, worm: worm)
        let crazy = WormCrazyState(game: game, worm: worm)
        let defeated = WormDefeatedState(game: game, worm: worm)
        
        stateMachine = GKStateMachine(states: [free, happy, crazy, defeated])
        stateMachine?.enterState(WormFreeState)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        stateMachine?.updateWithDeltaTime(seconds)
    }
}

//
//  WormDigestiveComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/13.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class WormDigestiveComponent: GKComponent {

    weak var game: Game?
    
    var wantEat: [TriggerSugarStyle]?
    
    init(game: Game?) {
        self.game = game
        
        super.init()
    }
    
    func eat() {
        
    }
    
    func digest() {
        
    }
    
    func shit() {
        
    }
}

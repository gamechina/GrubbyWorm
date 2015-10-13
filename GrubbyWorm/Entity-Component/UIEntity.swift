//
//  UI.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/8.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class UIEntity: Entity {
    
    func renderScore(score: Int) {
        if let spriteComponent = componentForClass(UISpriteComponent) {
            spriteComponent.score.text = String(score)
        }
    }
}

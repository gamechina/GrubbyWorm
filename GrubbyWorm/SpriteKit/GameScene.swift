//
//  Scene.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/28.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

protocol GameSceneDelegate : SKSceneDelegate {
    func didMoveToView(view: SKView)
}

class GameScene: SKScene {
    var gameDelegate: GameSceneDelegate?
    
    override func didMoveToView(view: SKView) {
        gameDelegate?.didMoveToView(view)
    }
}

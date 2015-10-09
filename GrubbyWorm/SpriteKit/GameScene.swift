//
//  Scene.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/28.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit
import ReplayKit

protocol GameSceneDelegate : SKSceneDelegate {
    func didMoveToView(view: SKView)
}

class GameScene: SKScene {
    
    var gameDelegate: GameSceneDelegate?
    
    var previewViewController: RPPreviewViewController?
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        gameDelegate?.didMoveToView(view)
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        gameDelegate?.update!(currentTime, forScene: self)
    }
}

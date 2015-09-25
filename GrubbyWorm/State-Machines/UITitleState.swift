//
//  TitleState.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/16.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit
import GameplayKit

class UITitleState: UIState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print("aaa")
        
        let title = SKLabelNode(text: "Grubby Worm")
        title.position = CGPointMake(100, 100)
        title.zPosition = 10
        
        self.game?.scene?.addChild(title)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("bbb")
    }
}

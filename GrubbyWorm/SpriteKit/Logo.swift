//
//  Logo.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/6.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

class Logo: SKNode {
    
    override init() {
        super.init()
        
        let mark = SKSpriteNode(imageNamed: "logo")
        mark.position = CGPointMake(0, 0)
        self.addChild(mark)
        
        let action = SKAction.moveBy(CGVectorMake(0, -100), duration: 3.6, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.5)
        mark.runAction(action)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

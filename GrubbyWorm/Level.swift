//
//  Level.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/4.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit
import GameplayKit

class Level : NSObject {
    
    // the playground size
    var size: CGSize
    
    var playground: Playground
    
    init(size: CGSize) {
        self.size = size
        playground = Playground(size: size)
        
        super.init()
    }
}

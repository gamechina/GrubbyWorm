//
//  GWSwitch.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/13.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import Foundation
import SpriteKit

class GWSwitch: SKSpriteNode {
    
    var onChange: ((GWSwitch) -> Void)?
    
    var openTexture: SKTexture
    var closeTexture: SKTexture
    
    var isOpen: Bool = false {
        didSet {
            texture = isOpen ? openTexture : closeTexture
            if let act = onChange {
                act(self)
            }
        }
    }
    
    init(openTexture: SKTexture, closeTexture: SKTexture) {
        self.openTexture = openTexture
        self.closeTexture = closeTexture
        
        super.init(texture: closeTexture, color: UIColor.whiteColor(), size: closeTexture.size())

        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let touchLocation = touch.locationInNode(parent!)
            
            if CGRectContainsPoint(frame, touchLocation) {
                isOpen = !isOpen
            }
        }
    }

}

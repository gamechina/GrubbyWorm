//
//  SpriteKit-Animation.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/12.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    func setRawPosition() {
        let value = NSValue(CGPoint: self.position)
        
        if userData == nil {
            userData = NSMutableDictionary()
        }
        
        self.userData?.setValue(value, forKey: Constant.user_data_key_raw_position)
    }
    
    func getRawPosition() -> CGPoint {
        if let value = self.userData?.valueForKey(Constant.user_data_key_raw_position) as? NSValue {
            return value.CGPointValue()
        } else {
            return CGPointZero
        }
    }
}

extension SKSpriteNode {
    
    func quickMoveTo(point: CGPoint) {
        let action = SKAction.moveTo(point, duration: 1.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3)
        
        self.runAction(action)
    }
    
    func slowMoveTo(point: CGPoint) {
        let action = SKAction.moveTo(point, duration: 1.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.55)
        
        self.runAction(action)
    }
    
    func shake() {
        if !hasActions() {
            let rawXScale = self.xScale
            let rawYScale = self.yScale
            
            self.xScale -= 0.2
            self.yScale -= 0.2
            
            let action = SKAction.scaleXBy(0.2, y: 0.2, duration: 0.8, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2)
            
            self.runAction(action) { () -> Void in
                self.xScale = rawXScale
                self.yScale = rawYScale
            }
        }
    }
}

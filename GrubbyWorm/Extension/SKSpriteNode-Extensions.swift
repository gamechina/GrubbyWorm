//
//  SpriteKit-Animation.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/12.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    
    func quickMoveTo(point: CGPoint) {
        let action = SKAction.moveTo(point, duration: 1.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3)
        
        self.runAction(action)
    }
    
    func slowMoveTo(point: CGPoint) {
        let action = SKAction.moveTo(point, duration: 1.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.55)
        
        self.runAction(action)
    }
    
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

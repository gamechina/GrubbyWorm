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
    
    func setRawScale() {
        let xScale = NSValue(nonretainedObject: self.xScale)
        let yScale = NSValue(nonretainedObject: self.yScale)
        
        if userData == nil {
            userData = NSMutableDictionary()
        }
        
        self.userData?.setValue(xScale, forKey: Constant.user_data_key_raw_xscale)
        self.userData?.setValue(yScale, forKey: Constant.user_data_key_raw_yscale)
    }
    
    func getRawXScale() -> CGFloat {
        if let value = self.userData?.valueForKey(Constant.user_data_key_raw_xscale) as? NSValue {
            return value.nonretainedObjectValue as! CGFloat
        }
        
        return 1.0
    }
    
    func getRawYScale() -> CGFloat {
        if let value = self.userData?.valueForKey(Constant.user_data_key_raw_yscale) as? NSValue {
            return value.nonretainedObjectValue as! CGFloat
        }
        
        return 1.0
    }
    
    func quickMoveTo(point: CGPoint) {
        let action = SKAction.moveTo(point, duration: 1.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3)
        
        self.runAction(action)
    }
    
    func slowMoveTo(point: CGPoint) {
        let action = SKAction.moveTo(point, duration: 1.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.55)
        
        self.runAction(action)
    }
    
    func shake() {
        if let _ = actionForKey(Constant.action_button_shake) {
            removeActionForKey(Constant.action_button_shake)
            self.xScale = getRawXScale()
            self.yScale = getRawYScale()
        }
        
        self.xScale -= 0.2
        self.yScale -= 0.2
        
        let shakeAction = SKAction.scaleXBy(0.2, y: 0.2, duration: 0.8, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2)
        let callBlock = SKAction.runBlock { () -> Void in
            self.xScale = self.getRawXScale()
            self.yScale = self.getRawYScale()
        }
        
        self.runAction(SKAction.sequence([shakeAction, callBlock]), withKey: Constant.action_button_shake)
    }
}

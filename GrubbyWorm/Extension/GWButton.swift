//
//  GWButton.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/28.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import Foundation
import SpriteKit

enum GWButtonTarget {
    case aSelector(Selector, AnyObject)
    case aBlock(() -> Void)
}

class GWButton: SKSpriteNode {
    var actionTouchUp: GWButtonTarget?
    var actionTouchUpInside: GWButtonTarget?
    var actionTouchDown: GWButtonTarget?
    
    var defaultTexture: SKTexture
    var selectedTexture: SKTexture
    var disabledTexture: SKTexture?
    
    var isEnabled: Bool = true {
        didSet {
            if disabledTexture != nil {
                texture = isEnabled ? defaultTexture : disabledTexture
            }
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            texture = isSelected ? selectedTexture : defaultTexture
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    convenience init(normalTexture defaultTexture: SKTexture!) {
        self.init(normalTexture: defaultTexture, selectedTexture: defaultTexture, disabledTexture: defaultTexture)
    }
    
    init(normalTexture defaultTexture: SKTexture!, selectedTexture: SKTexture!, disabledTexture: SKTexture?) {
        self.defaultTexture = defaultTexture
        self.selectedTexture = selectedTexture
        self.disabledTexture = disabledTexture
        
        super.init(texture: defaultTexture, color: UIColor.whiteColor(), size: defaultTexture.size())
        
        userInteractionEnabled = true
        
//        // Adding this node as an empty layer. Without it the touch functions are not being called
//        // The reason for this is unknown when this was implemented...?
//        let bugFixLayerNode = SKSpriteNode(color: SKColor.clearColor(), size: defaultTexture.size())
//        bugFixLayerNode.position = self.position
//        addChild(bugFixLayerNode)
    }
    
    func callTarget(buttonTarget: GWButtonTarget) {
        switch buttonTarget {
        case let .aSelector(selector, target):
            if target.respondsToSelector(selector) {
                UIApplication.sharedApplication().sendAction(selector, to: target, from: self, forEvent: nil)
            }
        case let .aBlock(block):
            block()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !isEnabled {
            return
        }
        
        isSelected = true
        
        if let act = actionTouchDown {
            callTarget(act)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !isEnabled {
            return
        }
        
        for touch in touches {
            let touchLocation = touch.locationInNode(parent!)
            
            if CGRectContainsPoint(frame, touchLocation) {
                isSelected = true
            } else {
                isSelected = false
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !isEnabled {
            return
        }
        
        isSelected = false
        
        for touch in touches {
            let touchLocation = touch.locationInNode(parent!)
            
            if CGRectContainsPoint(frame, touchLocation) {
                if let act = actionTouchUpInside {
                    callTarget(act)
                }
            }
            
            if let act = actionTouchUp {
                callTarget(act)
            }
        }
    }
}

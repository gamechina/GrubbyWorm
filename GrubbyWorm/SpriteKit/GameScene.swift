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
    func swipeTurnTo(direction: Direction)
}

class GameScene: SKScene {
    
    var gameDelegate: GameSceneDelegate?
    
    var startLocation: CGPoint?
    
    var previewViewController: RPPreviewViewController?
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
//        userInteractionEnabled = true
        gameDelegate?.didMoveToView(view)
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        gameDelegate?.update!(currentTime, forScene: self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        for touch in touches {
            startLocation = touch.locationInNode(self)
        }
    }
    
    // remove all gesture from storyboard, because the swipe gesture can not set the custom touch move distance.
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if let startLocation = startLocation {
            for touch in touches {
                let now = touch.locationInNode(self)
                let angle = (now - startLocation).angle * 57.29577951
                
                let distance = startLocation.distanceTo(now)
                
                print(startLocation.distanceTo(now))
                print(angle)
                
                if distance >= 10 {
                    if (angle >= 45 && angle < 135) {
                        gameDelegate?.swipeTurnTo(.Up)
                    } else if (angle >= -45 && angle < 45) {
                        gameDelegate?.swipeTurnTo(.Right)
                    } else if (angle >= -135 && angle < -45) {
                        gameDelegate?.swipeTurnTo(.Down)
                    } else {
                        gameDelegate?.swipeTurnTo(.Left)
                    }
                }
            }
        }
    }
}

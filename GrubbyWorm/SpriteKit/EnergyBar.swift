//
//  EnergyBar.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/29.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

class EnergyBar: SKNode {
    
    var barWidth: CGFloat = 0
    
    var percent: CGFloat {
        didSet {
            if percent <= 0 {
                percent = 0
            }
            renderProgress()
        }
    }
    
    private var _score: SKLabelNode!
    private var _down: SKSpriteNode!
    private var _up: SKSpriteNode!
    
    
    init(width: CGFloat) {
        barWidth = width
        percent = 0
        
        super.init()
        
        _down = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(width, Theme.mood_bar_height))
        _down.anchorPoint = CGPointMake(0, 0)
        self.addChild(_down)
        
        _up = SKSpriteNode(color: Theme.mood_bar_up_color, size: CGSizeMake(width, Theme.mood_bar_height))
        _up.anchorPoint = CGPointMake(0, 0)
        self.addChild(_up)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderProgress() {
        
    }
    
}

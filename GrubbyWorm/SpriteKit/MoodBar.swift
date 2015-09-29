//
//  MoodBar.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/29.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

class MoodBar: SKNode {
    
    var barWidth: CGFloat = 0
    
    var percent: CGFloat {
        didSet {
            if percent <= 0 {
                percent = 0
            }
            renderProgress()
        }
    }
    
    private var _down: SKSpriteNode!
    private var _up: SKSpriteNode!
    private var _mark: SKSpriteNode!
    
    init(width: CGFloat) {
        barWidth = width
        percent = 100
        
        super.init()
        
        _down = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(width, Theme.mood_bar_height))
        _down.anchorPoint = CGPointMake(0, 0)
        self.addChild(_down)
        
        _up = SKSpriteNode(color: Theme.mood_bar_up_color, size: CGSizeMake(width, Theme.mood_bar_height))
        _up.anchorPoint = CGPointMake(0, 0)
        self.addChild(_up)
        
        _mark = SKSpriteNode(color: Theme.mood_bar_up_color, size: CGSizeMake(10, 10))
        _mark.anchorPoint = CGPointMake(0.5, 0)
        _mark.position = CGPointMake(width, Theme.mood_bar_height + 2)
        self.addChild(_mark)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderProgress() {
        let width = (percent / 100) * barWidth
        _up.size = CGSizeMake(width, _up.size.height)
        _mark.position = CGPointMake(width, _mark.position.y)
    }
}

//
//  MoodBar.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/29.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

protocol MoodBarDelegate : NSObjectProtocol {
    func onMoodProgressEmpty(bar: MoodBar)
    func onMoodProgressFull(bar: MoodBar)
}

class MoodBar: SKNode {
    
    var comboCount: Int = 0
    
    var barWidth: CGFloat = 0
    
    var percent: CGFloat {
        didSet {
            if percent <= 0 {
                percent = 0
            }
            
            renderProgress()
        }
    }
    
    var delegate: MoodBarDelegate?
    
    private var _down: SKSpriteNode!
    private var _up: SKSpriteNode!
    private var _mark: SKNode!
    private var _value: Tip!
    
    init(width: CGFloat) {
        barWidth = width
        percent = 0
        
        super.init()
        
        _down = SKSpriteNode(color: Theme.mood_bar_down_color, size: CGSizeMake(width, Theme.mood_bar_height))
        _down.anchorPoint = CGPointMake(0, 0)
        self.addChild(_down)
        
        _up = SKSpriteNode(color: Theme.mood_bar_up_color, size: CGSizeMake(width, Theme.mood_bar_height))
        _up.anchorPoint = CGPointMake(0, 0)
        self.addChild(_up)
        
        _mark = SKNode()
        _mark.position = CGPointMake(width, Theme.mood_bar_height + 10)
        _mark.hidden = true
        self.addChild(_mark)
        
        _value = Tip(text: "")
        _value.fontColor = SKColor.blackColor()
        _mark.addChild(_value)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderProgress() {
        let width = (percent / 100) * barWidth
        _up.size = CGSizeMake(width, _up.size.height)
        _mark.position = CGPointMake(width, _mark.position.y)
        
        if comboCount == 0 {
            _value.text = "连击"
        } else {
            _value.text = String(comboCount)
        }
        
        if percent == 0 || percent == 100 {
            _mark.hidden = true
        } else {
            _mark.hidden = false
        }
        
        if percent == 0 {
            delegate?.onMoodProgressEmpty(self)
        }
    }
}

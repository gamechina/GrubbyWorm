//
//  EnergyBar.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/29.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

protocol EnergyBarDelegate: NSObjectProtocol {
    func onEnergyProgressEmpty(bar: EnergyBar)
    func onEnergyProgressFull(bar: EnergyBar)
}

class EnergyBar: SKNode {
    
    var barWidth: CGFloat = 0
    
    var percent: CGFloat {
        didSet {
            if percent >= 100 {
                percent = 0
            }
            
            renderProgress()
        }
    }
    
    var dropping: Bool = false
    
    var delegate: EnergyBarDelegate?
    
    private var _score: SKLabelNode!
    private var _down: SKSpriteNode!
    private var _up: SKSpriteNode!
    
    init(width: CGFloat) {
        barWidth = width - Theme.energy_bar_margin * 2
        percent = 0
        
        super.init()
        
        _down = SKSpriteNode(color: Theme.energy_bar_down_color, size: CGSizeMake(barWidth, Theme.energy_bar_height))
        _down.anchorPoint = CGPointMake(0, 0)
        _down.position = CGPointMake(Theme.energy_bar_margin, (Theme.top_bar_board_height - Theme.energy_bar_height) / 2)
        self.addChild(_down)
        
        _up = SKSpriteNode(color: Theme.energy_bar_up_color, size: CGSizeMake(0, Theme.energy_bar_height))
        _up.anchorPoint = CGPointMake(0, 0)
        _up.position = CGPointMake(Theme.energy_bar_margin, (Theme.top_bar_board_height - Theme.energy_bar_height) / 2)
        self.addChild(_up)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderProgress() {
        let width = (percent / 100) * barWidth
        _up.size = CGSizeMake(width, _up.size.height)
        
        if percent == 100 {
            dropping = true
            delegate?.onEnergyProgressFull(self)
        }
        
        if percent == 0 {
            dropping = false
            delegate?.onEnergyProgressEmpty(self)
        }
    }
    
}

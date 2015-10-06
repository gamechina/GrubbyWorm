//
//  AppTheme.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/13.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

struct Theme {
    
    // --------- Colors ---------
    static let primary_color = SKColorWithRGB(251, g: 63, b: 72)
    static let secondary_color = SKColorWithRGB(200, g: 200, b: 200)
    
    static let temp_color = SKColorWithRGB(80, g: 180, b: 120)
    
    static let scene_background_color = SKColorWithRGB(200, g: 200, b: 80)
    
    static let btn_play_color = SKColorWithRGB(200, g: 200, b: 200)
    
    static let mood_bar_up_color = SKColorWithRGB(80, g: 180, b: 120)
    static let mood_bar_down_color = SKColorWithRGB(60, g: 110, b: 60)
    
    static let energy_bar_up_color = SKColorWithRGB(80, g: 180, b: 120)
    static let energy_bar_down_color = SKColorWithRGB(60, g: 110, b: 60)
    
    static let mask_color = SKColorWithRGBA(0, g: 0, b: 0, a: 160)
    
    static let tile_normal_color = SKColorWithRGB(250, g: 250, b: 250)
    static let tile_marble_color = SKColorWithRGB(245, g: 245, b: 245)
    
    // --------- Config ---------
    
    static let mini_margin: CGFloat = 2
    
    static let mood_bar_height: CGFloat = 3
    
    static let top_bar_board_height: CGFloat = 32
    static let energy_bar_height: CGFloat = 22
    static let energy_bar_margin: CGFloat = 80
    
    static let tile_interval: CGFloat = 0.5
}

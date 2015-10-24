//
//  Constant.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/9.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import Foundation
import SpriteKit

struct Constant {
    static let leaderboard_id = "LB_GrubbyWorm_2"
    
    static let user_data_key_raw_position = "raw position"
    static let user_data_key_raw_xscale = "raw xscale"
    static let user_data_key_raw_yscale = "raw yscale"
    
    static let user_data_key_auto_recording = "auto recording"
    
    static let action_button_shake = "action button shake"
    static let action_key_playground = "action key playground"
    
    static let tip_name_eat_me = "tip eat me"
    static let trigger_display_name = "trigger display name"
    static let action_key_eat_me = "action key eat me"
    
    static let worm_normal_speed: NSTimeInterval = 0.35
    static let worm_combo_speed: NSTimeInterval = 0.23
    static let worm_crazy_speed: NSTimeInterval = 0.12
    
    static let combo_continue_time: CGFloat = 10
    static let energy_drop_time: CGFloat = 10
    
    // sound file name
    static let background_sound = "playwithme.mp3"
    static let lose_sound = "lose.wav"
    
    static let button_tap_sound = "tap.wav"
    
    static let worm_step_sound = "step.mp3"
    static let worm_shit_sound = "shit.wav"
    
}

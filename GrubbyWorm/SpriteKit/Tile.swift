//
//  Tile.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/6.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

enum TileStyle {
    case Normal
    case Marble
}

class Tile: SKSpriteNode {
    
    var style: TileStyle
    
    var location: Location
    
    var hasTrigger: Bool
    
    init(location: Location, style: TileStyle = .Normal) {
        self.style = style
        self.location = location
        hasTrigger = false
        
        let size = CGSizeMake(38, 38)
        
        super.init(texture: nil, color: SKColor.clearColor(), size: size)
        
        renderStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func renderStyle() {
        switch style {
        case .Normal:
            color = Theme.tile_normal_color
            break
        case .Marble:
            color = Theme.tile_marble_color
            break
        }
    }
    
    func renderLocation() {
        let label = SKLabelNode(text: "\(location.row), \(location.col)")
        label.fontColor = UIColor.blackColor()
        label.fontSize = 8
        
        addChild(label)
    }
}


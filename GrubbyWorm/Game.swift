//
//  Game.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/23.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit
import GameplayKit

class Game: NSObject {
    
    // reference the current scene instance, in grubby worm game, we have only one scene.
    var scene: SKScene?
    
    // game ui, for play, pause and display.
    var ui: Entity?
    
    // reference the game logic level(in grubby worm it should be a map or playground).
    private var _level: NSObject?
    
    // all triggers(include sugar, grubby, all have effect with the worm).
    private var _triggers: [Entity]?
    
    // player control worm, our leading role.
    private var _worm: Entity?
    
    // worm direction
    var wormDirection: Direction = .None
    
    // random source
    var random: GKRandomSource?
    
    override init() {
        super.init()
        
        initScene()
//        initUI()
    }
    
    // init the only game scene.
    func initScene() {
        scene = SKScene()
        
        scene?.scaleMode = .AspectFill
        scene?.backgroundColor = AppTheme.scene_background_color
        
        let aaa = SKLabelNode(text: "aaa")
        aaa.fontSize = 25
        aaa.fontColor = AppTheme.secondary_color
        aaa.position = CGPointMake(100, 100)
        scene?.addChild(aaa)
        
//        let spaceship = SKSpriteNode(imageNamed: "Spaceship")
//        scene?.addChild(spaceship)
    }
    
    func initUI() {
        ui = Entity()
        
        ui?.addComponent(GameControlComponent(game: self, ui: ui))
        ui?.addComponent(UISpriteComponent(game: self, ui: ui))
    }
    
}

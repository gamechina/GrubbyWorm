//
//  Game.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/23.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit
import GameplayKit

class Game: NSObject, GameSceneDelegate {
    
    private var _view: SKView
    
    // reference the current scene instance, in grubby worm game, we have only one scene.
    var scene: GameScene?
    
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
    
    init(view: SKView) {
        self._view = view
        
        super.init()
        initScene()
    }
    
    // init the only game scene.
    func initScene() {
        scene = GameScene(size: CGSizeMake(_view.frame.width, _view.frame.height))
        scene?.gameDelegate = self
        
        scene?.scaleMode = .AspectFill
        scene?.backgroundColor = AppTheme.scene_background_color
    }
    
    func initUI() {
        ui = Entity()
        
        ui?.addComponent(GameControlComponent(game: self, ui: ui))
        ui?.addComponent(UISpriteComponent(game: self, ui: ui))
    }
    
    func didMoveToView(view: SKView) {
        initUI()
    }
    
}

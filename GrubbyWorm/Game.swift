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
    var scene: GameScene
    
    // game ui, for play, pause and display.
    var ui: Entity?
    
    // reference the game logic level(in grubby worm it should be a map or playground).
    var level: Level!
    
    // all triggers(include sugar, grubby, all have effect with the worm).
    private var _triggers: [Entity]?
    
    // player control worm, our leading role.
    private var _worm: Entity?
    
    // worm direction
    var wormDirection: Direction = .None
    
    // random source
    var random: GKRandomSource?
    
    var prevUpdateTime: NSTimeInterval = 0
    
    init(view: SKView) {
        _view = view
        scene = GameScene(size: _view.bounds.size)
        
        super.init()
        initScene()
    }
    
    // init the only game scene.
    func initScene() {
        scene.gameDelegate = self
        
        scene.scaleMode = .AspectFill
        scene.backgroundColor = Theme.scene_background_color
    }
    
    func initUI() {
        ui = Entity()
        
        ui?.addComponent(UISpriteComponent(game: self, ui: ui))
        ui?.addComponent(GameControlComponent(game: self, ui: ui))
    }
    
    func didMoveToView(view: SKView) {
        initUI()
    }
    
    func update(currentTime: NSTimeInterval, forScene scene: SKScene) {
        
        // Track the time delta since the last update.
        if prevUpdateTime < 0 {
            prevUpdateTime = currentTime
        }
        
        let dt = currentTime - prevUpdateTime
        prevUpdateTime = currentTime
        
        self.ui?.updateWithDeltaTime(dt)
    }
    
    func startGame() {
        initLevel()
    }
    
    func initLevel() {
        level = Level(size: _view.frame.size)
    }
    
}

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
    var ui: Entity
    
    // reference the game logic level(in grubby worm it should be a map or playground).
    var level: Level!
    
    // all triggers(include sugar, grubby, all have effect with the worm).
    var triggers: [Trigger]
    
    // player control worm, our leading role.
    var worm: Worm
    
    // worm direction
    var wormDirection: Direction = .Right
    
    // random source
    var random: GKRandomSource?
    
    var prevUpdateTime: NSTimeInterval = 0
    
    init(view: SKView) {
        _view = view
        scene = GameScene(size: _view.bounds.size)
        
        ui = Entity()
        worm = Worm()
        
        triggers = []
        
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
        ui.addComponent(UISpriteComponent(game: self, ui: ui))
        ui.addComponent(GameControlComponent(game: self, ui: ui))
    }
    
    func initWorm() {
        worm.addComponent(WormControlComponent(game: self, ui: ui))
        worm.addComponent(WormSpriteComponent(game: self, ui: ui))
        
        level.playground.addWorm(worm, location: Location(row: 0, col: 0))
    }
    
    func didMoveToView(view: SKView) {
        initUI()
        initLevel()
        initWorm()
    }
    
    func update(currentTime: NSTimeInterval, forScene scene: SKScene) {
        
        // Track the time delta since the last update.
        if prevUpdateTime < 0 {
            prevUpdateTime = currentTime
        }
        
        let dt = currentTime - prevUpdateTime
        prevUpdateTime = currentTime
        
        ui.updateWithDeltaTime(dt)
        worm.updateWithDeltaTime(dt)
        
        // check trigger
        if let wormLoc = worm.componentForClass(WormSpriteComponent)?.locations[0] {
            for trigger in triggers {
                if trigger.location.equal(wormLoc) {
                    fireTrigger(trigger)
                }
            }
        }
    }
    
    func startGame() {
        
        // add some trigger
        let a = Trigger(location: Location(row: 2, col: 2))
        a.addComponent(TriggerSpriteComponent())
        let b = Trigger(location: Location(row: 4, col: 4))
        b.addComponent(TriggerSpriteComponent())
        
        addTrigger(a)
        addTrigger(b)
    }
    
    func initLevel() {
        level = Level(size: _view.frame.size)
        let playground = level.playground
        playground.position = CGPointMake(_view.frame.midX, _view.frame.midY)
        scene.addChild(level.playground)
    }
    
    func addTrigger(trigger: Trigger) {
        if level.playground.addTrigger(trigger) {
            triggers.append(trigger)
        }
    }
    
    func fireTrigger(trigger: Trigger) {
        worm.fireTrigger(trigger)
        trigger.fired()
        
        if let index = triggers.indexOf(trigger) {
            triggers.removeAtIndex(index)
        }
    }
    
}

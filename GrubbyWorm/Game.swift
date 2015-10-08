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
    
    // MARK: Private Properties
    
    // application view for running skscene.
    private var _view: SKView
    
    // MARK: Public Properties
    
    // reference the current scene instance, in grubby worm game, we have only one scene.
    var scene: GameScene
    
    // game ui, for play, pause and display, show different ui states appearance.
    var ui: UIEntity
    
    // reference the game logic level(in grubby worm it should be a map or playground).
    var level: Level
    
    // all triggers(include sugar, grubby, all have effect with the worm).
    var triggers: [TriggerEntity]
    
    // player controlled worm, our leading role.
    var worm: WormEntity
    
    // worm direction
    var wormDirection: Direction = .Right
    
    // random distribution, for generate triggers locations.
    var rowRandom: GKRandomDistribution?
    
    // random distribution, for generate triggers locations.
    var colRandom: GKRandomDistribution?
    
    var locationRandomSplit: NSTimeInterval = 0.01
    
    // for caculate the delta time in update method.
    var prevUpdateTime: NSTimeInterval = 0
    
    // MARK: Initializers
    
    init(view: SKView) {
        _view = view
        
        scene = GameScene(size: _view.bounds.size)
        ui = UIEntity()
        level = Level(size: _view.bounds.size)
        worm = WormEntity(ui: ui)
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
        ui.addComponent(UISpriteComponent(game: self))
        ui.addComponent(UIControlComponent(game: self, ui: ui))
    }
    
    func initWorm() {
        worm.addComponent(WormControlComponent(game: self, ui: ui))
        worm.addComponent(WormSpriteComponent(game: self, ui: ui))
        
        level.playground.addWorm(worm, location: Location(row: 0, col: 0))
    }
    
    func didMoveToView(view: SKView) {
        initUI()
        initLevel()
        initRandomSource()
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
        let a = TriggerEntity(location: Location(row: 2, col: 2))
        a.addComponent(TriggerSpriteComponent())
        let b = TriggerEntity(location: Location(row: 4, col: 4))
        b.addComponent(TriggerSpriteComponent())
        
        addTrigger(a)
        addTrigger(b)
        
        initWorm()
    }
    
    func resumeGame() {
        
    }
    
    func initLevel() {
        let playground = level.playground
        playground.position = CGPointMake(_view.frame.midX, _view.frame.midY)
        scene.addChild(level.playground)
    }
    
    func addTrigger(trigger: TriggerEntity) {
        if level.playground.addTrigger(trigger) {
            triggers.append(trigger)
        }
    }
    
    func fireTrigger(trigger: TriggerEntity) {
        worm.fireTrigger(trigger)
        trigger.fired()
        
        if let index = triggers.indexOf(trigger) {
            triggers.removeAtIndex(index)
        }
    }
    
    func initRandomSource() {
        let playground = level.playground
        let range = playground.getGridSizeRange()
        rowRandom = GKRandomDistribution(lowestValue: range.from.row, highestValue: range.to.row)
        colRandom = GKRandomDistribution(lowestValue: range.from.col, highestValue: range.to.col)
    }
    
    func getRandomLocation() -> Location {
        if rowRandom != nil && colRandom != nil {
            return Location(row: rowRandom!.nextInt(), col: colRandom!.nextInt())
        }
        
        return Location(row: 0, col: 0)
    }
    
    func addRandomTrigger() {
        let loc = getRandomLocation()
        
        let t = TriggerEntity(location: loc)
        t.addComponent(TriggerSpriteComponent())
        
        addTrigger(t)
    }
    
}

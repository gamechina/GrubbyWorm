//
//  Game.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/23.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class Game: NSObject, GameSceneDelegate, WormDelegate {
    
    // MARK: Private Properties
    
    // application view for running skscene.
    private var _view: SKView
    
    private var _motionManager: CMMotionManager!
    
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
    var worm: WormEntity?
    
    // worm direction
    var wormDirection: Direction = .Right
    
    // random distribution, for generate triggers locations.
    var rowRandom: GKRandomDistribution?
    
    // random distribution, for generate triggers locations.
    var colRandom: GKRandomDistribution?
    
    // random rule system
    var randomRuleSystem: GKRuleSystem?
    
    var locationRandomSplit: NSTimeInterval = 0.5
    
    // for caculate the delta time in update method.
    var prevUpdateTime: NSTimeInterval = 0
    
    // score
    var score: Int {
        didSet {
            ui.renderScore(score)
        }
    }
    
    var energy: EnergyInfo {
        didSet {
            ui.renderEnergy(energy)
        }
    }
    
    // MARK: Initializers
    
    init(view: SKView) {
        _view = view
        _motionManager = CMMotionManager()
        
        scene = GameScene(size: _view.bounds.size)
        ui = UIEntity()
        level = Level(size: _view.bounds.size)
        triggers = []
        score = 0
        energy = EnergyInfo(total: 100, current: 0, round: 0)
        
        super.init()
        
        initScene()
        addObservers()
    }
    
    // init the only game scene.
    func initScene() {
        scene.gameDelegate = self
        
        scene.scaleMode = .AspectFill
        scene.backgroundColor = Theme.scene_background_color
    }
    
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enterBackground:", name: "enter background", object: nil)
    }
    
    func enterBackground(notification: NSNotification) {
        pause()
    }
    
    func initUI() {
        ui.addComponent(UISpriteComponent(game: self))
        ui.addComponent(UIControlComponent(game: self, ui: ui))
    }
    
    func initWorm() {
        worm = WormEntity(game: self, ui: ui)
        worm?.delegate = self
        worm?.addComponent(WormDigestiveComponent(game: self))
        worm?.addComponent(WormControlComponent(game: self, worm: worm))
        worm?.addComponent(WormSpriteComponent(game: self, ui: ui))
        
        level.playground.addWorm(worm!, location: Location(row: 0, col: 0))
    }
    
    func didMoveToView(view: SKView) {
        initUI()
        initLevel()
        initRandomSource()
        initWorm()
    }
    
    func swipeTurnTo(direction: Direction) {
        if let wormSprite = worm?.componentForClass(WormSpriteComponent) {
            wormSprite.turn(direction)
        }
    }
    
    func update(currentTime: NSTimeInterval, forScene scene: SKScene) {
        
        // Track the time delta since the last update.
        if prevUpdateTime < 0 {
            prevUpdateTime = currentTime
        }
        
        let dt = currentTime - prevUpdateTime
        prevUpdateTime = currentTime
        
        ui.updateWithDeltaTime(dt)
        worm?.updateWithDeltaTime(dt)
        
        // check trigger
        for trigger in triggers {
            if let worm = worm {
                if trigger.location.equal(worm.headLocation()) && trigger.born {
                    
                    fireTrigger(trigger)
                }
            }
        }
        
        showSugarTips()
    }
    
    func startGame() {
        if let wormStateMachine = worm?.componentForClass(WormControlComponent)?.stateMachine {
            wormStateMachine.enterState(WormHappyState)
        }
        
        scene.startScreenRecording()
        
        level.playground.playSound()
    }
    
    func resumeGame() {
        scene.startScreenRecording()
    }
    
    func restartGame() {
        if let wormStateMachine = worm?.componentForClass(WormControlComponent)?.stateMachine {
            wormStateMachine.enterState(WormHappyState)
        }
        
        removeAllTriggers()
        
        score = 0
        energy = EnergyInfo(total: 100, current: 0, round: 0)
        
        // reset worm's combo
        worm?.resetCombo()
    }
    
    func initLevel() {
        let playground = level.playground
        playground.position = CGPointMake(_view.frame.midX, _view.frame.midY)
        playground.setRawPosition()
        scene.addChild(level.playground)
    }
    
    func removeAllTriggers() {
        for trigger in triggers {
            trigger.fired()
            
            if let index = triggers.indexOf(trigger) {
                triggers.removeAtIndex(index)
            }
            
            if let tile = level.playground.tileByLocation(trigger.location) {
                tile.hasTrigger = false
            }
        }
    }
    
    func addTrigger(trigger: TriggerEntity) -> Bool {
        if level.playground.addTrigger(trigger) {
            triggers.append(trigger)
            
            print("triggers: \(triggers.count)")
            return true
        } else {
            return false
        }
    }
    
    func fireTrigger(trigger: TriggerEntity) {
        worm?.eat(trigger)
        trigger.fired()
        
        if let index = triggers.indexOf(trigger) {
            triggers.removeAtIndex(index)
        }
        
        if let tile = level.playground.tileByLocation(trigger.location) {
            tile.hasTrigger = false
        }
    }
    
    func initRandomSource() {
        let playground = level.playground
        let range = playground.getGridSizeRange()
        
        rowRandom = GKRandomDistribution(lowestValue: range.from.row, highestValue: range.to.row)
        colRandom = GKRandomDistribution(lowestValue: range.from.col, highestValue: range.to.col)
        
        randomRuleSystem = GKRuleSystem()
    }
    
    func getRandomLocation() -> Location {
        if rowRandom != nil && colRandom != nil {
            return Location(row: rowRandom!.nextInt(), col: colRandom!.nextInt())
        }
        
        return Location(row: 0, col: 0)
    }
    
    func addRandomTrigger() {
        let loc = getRandomLocation()
        
        var t: TriggerEntity
        if triggers.count % 10 == 0 {
            t = CandyTriggerEntity(location: loc)
        } else {
            t = SugarTriggerEntity(location: loc, style: TriggerSugarStyle.randomStyle())
        }
        
        addTrigger(t)
    }
    
    func reportScore() {
        EasyGameCenter.reportScoreLeaderboard(leaderboardIdentifier: Constant.leaderboard_id, score: score)
    }
    
    func stopRecord() {
        if let uiSprite = ui.componentForClass(UISpriteComponent) {
            if uiSprite.recordSwitch.isOpen {
                scene.stopScreenRecordingWithHandler({ () -> Void in
                    print("recorded")
                    
                    uiSprite.replayButton.hidden = false
                })
            }
        }
    }
    
    // user action quick method
    func pause() {
        if let stateMachine = ui.componentForClass(UIControlComponent)?.stateMachine {
            if stateMachine.currentState == stateMachine.stateForClass(UIPlayingState) {
                stateMachine.enterState(UIPauseState)
            }
        }
    }
    
    func startGyroUpdate() {
        if _motionManager.gyroAvailable {
            _motionManager.gyroUpdateInterval = 0.1
            _motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!) { [weak self] (data: CMGyroData?, error: NSError?) in
                self?.outputGyroData(data?.rotationRate)
            }
        }
    }
    
    func stopGyroUpdate() {
        _motionManager.stopGyroUpdates()
    }
    
    func outputGyroData(rotationRate: CMRotationRate?) {
        
        //set playground position
        if let rotationRate = rotationRate {
            
            level.playground.removeActionForKey(Constant.action_key_playground)
            let rawPos = level.playground.getRawPosition()
            let moveToPos = CGPointMake(rawPos.x + CGFloat(rotationRate.x * 10), rawPos.y + CGFloat(rotationRate.y * 10))
            
            let action = SKAction.moveTo(moveToPos, duration: 0.1)
            
            level.playground.runAction(action, withKey: Constant.action_key_playground)
        }
    }
    
    func wormDead(worm: WormEntity) {
        if let uiStateMachine = ui.componentForClass(UIControlComponent)?.stateMachine {
            uiStateMachine.enterState(UIGameOverState)
        }
    }
    
    func showSugarTips() {
        if let wormDigestive = worm?.componentForClass(WormDigestiveComponent) {
            let wormWantEatNow = wormDigestive.wantEatNow()
            
            for trigger in triggers {
                if trigger.type() == .Sugar {
                    if let sugar = trigger as? SugarTriggerEntity {
                        if sugar.sugarStyle() == wormWantEatNow {
                            sugar.showTip()
                        } else {
                            sugar.hideTip()
                        }
                    }
                }
            }
        }
    }
}

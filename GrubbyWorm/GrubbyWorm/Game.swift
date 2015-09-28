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
    
    override init() {
        super.init()
        
        initScene()
    }
    
    // init the only game scene.
    func initScene() {
        scene = GameScene()
        scene?.gameDelegate = self
        
        scene?.scaleMode = .AspectFill
//        scene?.backgroundColor = AppTheme.scene_background_color
    }
    
    func initUI() {
        ui = Entity()
        
        ui?.addComponent(GameControlComponent(game: self, ui: ui))
        ui?.addComponent(UISpriteComponent(game: self, ui: ui))
    }
    
    func didMoveToView(view: SKView) {
//        initUI()
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(scene!.frame), y:CGRectGetMidY(scene!.frame))
        
        scene?.addChild(myLabel)
        
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = CGPoint(x:CGRectGetMidX(scene!.frame), y:CGRectGetMidY(scene!.frame))
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        
        sprite.runAction(SKAction.repeatActionForever(action))
        
        scene?.addChild(sprite)
    }
    
}

//
//  UISpriteComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/24.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit
import SpriteKit

class UISpriteComponent: GKComponent {
    
    private weak var _game: Game?
    private var _ui: Entity?
    
    var root: SKNode
    var logo: SKLabelNode?
    var menu: SKSpriteNode?
    var camera: SKCameraNode?
    
    init(game: Game?, ui: Entity?) {
        self._game = game
        self._ui = ui
        
        self.root = SKNode()
        
        super.init()
        
        initItems()
    }
    
    func initItems() {
        _game?.scene?.addChild(root)
        
        logo = SKLabelNode(text: "Grubby Worm")
        logo?.position = CGPointMake(100, 100)
        root.addChild(logo!)
        
        menu = SKSpriteNode(imageNamed: "Spaceship")
        menu?.position = CGPointMake(200, 200)
        menu?.setScale(0.5)
        root.addChild(menu!)
        
        camera = SKCameraNode()
        _game?.scene?.addChild(camera!)
        
        let move = SKAction.moveByX(10, y: 200, duration: 0.8)
        camera?.runAction(move)
        
        let texture = SKTexture(imageNamed: "Spaceship")
        let button = GWButtonNode(normalTexture: texture, selectedTexture: texture, disabledTexture: texture)
        button.position = CGPointMake(300, 200)
        button.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("button click")
        })
        
        root.addChild(button)
    }
    
    func useTitleAppearance() {
        
    }
    
    func usePlayingAppearance() {
        
    }
    
    func usePauseAppearance() {
        
    }
    
    func useGameOverAppearance() {
        
    }
}

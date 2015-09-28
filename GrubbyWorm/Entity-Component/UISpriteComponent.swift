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
    
    var logo: SKLabelNode?
    var menu: SKSpriteNode?
    
    init(game: Game?, ui: Entity?) {
        self._game = game
        self._ui = ui
        
        super.init()
        
        initItems()
    }
    
    func initItems() {
        let scene = _game?.scene
        
        logo = SKLabelNode(text: "Grubby Worm")
        logo?.position = CGPointMake(100, 100)
        scene?.addChild(logo!)
        
        menu = SKSpriteNode(imageNamed: "Spaceship")
        menu?.position = CGPointMake(200, 300)
        scene?.addChild(menu!)
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

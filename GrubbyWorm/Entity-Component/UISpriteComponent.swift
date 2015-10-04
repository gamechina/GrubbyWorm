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
    var button: GWButtonNode?
    
    var energyBar: EnergyBar!
    var moodBar: MoodBar!
    
    init(game: Game?, ui: Entity?) {
        self._game = game
        self._ui = ui
        
        self.root = SKNode()
        
        super.init()
        
        initItems()
    }
    
    func initItems() {
        root.zPosition = 100
        _game?.scene?.addChild(root)
        
        logo = SKLabelNode(text: "Grubby Worm")
        logo?.fontName = "Stiff Staff"
        logo?.position = CGPointMake(100, 100)
        logo?.fontColor = Theme.temp_color
        root.addChild(logo!)
        
        menu = SKSpriteNode(imageNamed: "Spaceship")
        menu?.position = CGPointMake(200, 200)
        menu?.setScale(0.5)
        root.addChild(menu!)
        
        let texture = SKTexture(imageNamed: "Spaceship")
        let selectedTexture = SKTexture(imageNamed: "Spaceship_h")
        button = GWButtonNode(normalTexture: texture, selectedTexture: selectedTexture, disabledTexture: texture)
        button!.position = CGPointMake(300, 200)
        button!.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("button click")
            self.entity?.componentForClass(GameControlComponent)?.stateMachine?.enterState(UIPlayingState)
        })
        
        root.addChild(button!)
        
        moodBar = MoodBar(width: (_game?.scene?.size.width)!)
        moodBar.position = CGPointMake(0, 0)
        moodBar.hidden = true
        root.addChild(moodBar)
        
        energyBar = EnergyBar(width: (_game?.scene?.size.width)!)
        energyBar.position = CGPointMake(0, (_game?.scene?.size.height)! - Theme.energy_bar_height)
        energyBar.hidden = true
        root.addChild(energyBar)
        
        let score = SKLabelNode(fontNamed: "Stiff Staff")
        score.text = "286"
        score.fontSize = 30
        score.position = CGPointMake(8, (_game?.scene?.size.height)! - Theme.energy_bar_height - 4)
        score.horizontalAlignmentMode = .Left
        score.verticalAlignmentMode = .Top
        score.fontColor = Theme.temp_color
        root.addChild(score)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    func useTitleAppearance() {
        let action = SKAction.rotateByAngle(100, duration: 0.5)
        logo?.runAction(action)
    }
    
    func usePlayingAppearance() {
        logo?.hidden = true
        button?.hidden = true
        let action = SKAction.moveBy(CGVectorMake(0, 500), duration: 0.5)
        menu?.runAction(action) {
            self.menu?.hidden = true
            self.moodBar.hidden = false
            self.energyBar.hidden = false
            print("finished")
        }
    }
    
    func usePauseAppearance() {
        
    }
    
    func useGameOverAppearance() {
        
    }
}

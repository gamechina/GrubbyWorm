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
    
    // MARK: Static properties
    
    
    // MARK: Private properties
    
    private var _game: Game
    private var _ui: Entity?
    
    // MARK: Properties
    
    // current scene size
    var sceneSize: CGSize
    
    // all ui elements root node.
    let root: SKNode
    
    // top root node for contain all top elements: score, energy bar, pause button.
    let topRoot: SKNode
    
    // label show current score
    var score: SKLabelNode
    
    // show the worm's current energy
    var energyBar: EnergyBar
    
    // pause button
    var pauseButton: GWButton
    
    // show the worm's mood :)
    var moodBar: MoodBar
    
    // grubby worm logo
    var logo: Logo
    
    // play button
    var playButton: GWButton
    
    // MARK: Initializers
    
    init(game: Game, ui: Entity?) {
        _game = game
        _ui = ui
        sceneSize = _game.scene.size
        
        root = SKNode()
        topRoot = SKNode()
        topRoot.position = CGPointMake(0, sceneSize.height - Theme.top_bar_board_height)
        
        // base nodes tree
        root.zPosition = 100
        _game.scene.addChild(root)
        root.addChild(topRoot)
        
        let topBoard = SKSpriteNode(color: Theme.primary_color, size: CGSizeMake(sceneSize.width, Theme.top_bar_board_height))
        topBoard.anchorPoint = CGPointMake(0, 0)
        
        score = SKLabelNode(fontNamed: "Stiff Staff")
        score.fontSize = 26
        score.text = "0"
        score.verticalAlignmentMode = .Center
        score.position = CGPointMake(Theme.energy_bar_margin / 2, Theme.top_bar_board_height / 2)
        
        energyBar = EnergyBar(width: sceneSize.width)
        
        // pause button
        pauseButton = GWButton(normalTexture: SKTexture(imageNamed: "tip"))
        pauseButton.size = CGSizeMake(30, 30)
        pauseButton.position = CGPointMake(sceneSize.width - Theme.energy_bar_margin / 2, Theme.top_bar_board_height / 2)
        
        topRoot.addChild(topBoard)
        topRoot.addChild(energyBar)
        topRoot.addChild(score)
        topRoot.addChild(pauseButton)
        
        moodBar = MoodBar(width: sceneSize.width)
        moodBar.position = CGPointMake(0, 0)
        moodBar.hidden = true
        root.addChild(moodBar)
        
        logo = Logo()
        logo.position = CGPointMake(sceneSize.width / 2, sceneSize.height)
        root.addChild(logo)
        
        // play button
        playButton = GWButton(normalTexture: SKTexture(imageNamed: "tip"))
        playButton.size = CGSizeMake(100, 100)
        playButton.position = CGPointMake(sceneSize.width / 2, sceneSize.height / 2 - 80)
        root.addChild(playButton)
        
        let playLabel = SKLabelNode(fontNamed: "Stiff Staff")
        playLabel.text = "PLAY"
        playLabel.verticalAlignmentMode = .Center
        playButton.addChild(playLabel)
        
        super.init()
        
        // some style and callback
        registerEvent()
    }
    
    func registerEvent() {
        
        pauseButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click pause")
            self.entity?.componentForClass(GameControlComponent)?.stateMachine?.enterState(UIPauseState)
        })
        
        playButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click play")
            self.entity?.componentForClass(GameControlComponent)?.stateMachine?.enterState(UIPlayingState)
        })
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    func useTitleAppearance() {
        playButton.hidden = false
        moodBar.hidden = true
        topRoot.hidden = true
    }
    
    func usePlayingAppearance() {
        logo.hidden = true
        playButton.hidden = true
        moodBar.hidden = false
        topRoot.hidden = false
    }
    
    func usePauseAppearance() {
        playButton.hidden = false
    }
    
    func useGameOverAppearance() {
        
    }
}

//
//  UISpriteComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/24.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit
import SpriteKit

class UISpriteComponent: GKComponent, MoodBarDelegate {
    
    // MARK: Static properties
    
    
    // MARK: Private properties
    
    private var _game: Game
    
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
    
    // pause mask
    var pauseMask: SKSpriteNode
    
    // show the worm's mood :)
    var moodBar: MoodBar
    
    // grubby worm logo
    var logo: Logo
    
    // play button
    var playButton: GWButton
    
    // how button
    var howButton: GWButton
    
    // game center button
    var gameCenterButton: GWButton
    
    // restart button
    var restartButton: GWButton
    
    // MARK: Initializers
    
    init(game: Game) {
        _game = game
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
        pauseButton.size = CGSizeMake(24, 24)
        pauseButton.position = CGPointMake(sceneSize.width - Theme.energy_bar_margin / 2, Theme.top_bar_board_height / 2)
        
        let pauseLabel = SKLabelNode(fontNamed: "FontAwesome")
        pauseLabel.text = "\u{f04c}"
        pauseLabel.fontSize = 18
        pauseLabel.verticalAlignmentMode = .Center
        pauseButton.addChild(pauseLabel)
        
        pauseMask = SKSpriteNode(color: Theme.mask_color, size: sceneSize)
        pauseMask.anchorPoint = CGPointMake(0, 0)
        pauseMask.zPosition = 1
        pauseMask.hidden = true
        root.addChild(pauseMask)
        
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
        playButton = GWButton(normalTexture: SKTexture(imageNamed: "btn_play"))
        playButton.size = CGSizeMake(120, 120)
        playButton.position = CGPointMake(sceneSize.width / 2, sceneSize.height / 2 - 90)
        playButton.zPosition = 2
        root.addChild(playButton)
        
        let howNormalTexture = SKTexture(imageNamed: "icon_how")
        howButton = GWButton(normalTexture: howNormalTexture)
        howButton.size = CGSizeMake(60, 60)
        howButton.position = playButton.position + CGPointMake(140, 0)
        howButton.zPosition = 2
        root.addChild(howButton)
        
        let gameCenterNormalTexture = SKTexture(imageNamed: "icon_game_center_normal")
        let gameCenterDisabledTexture = SKTexture(imageNamed: "icon_game_center_disabled")
        gameCenterButton = GWButton(normalTexture: gameCenterNormalTexture, selectedTexture: gameCenterNormalTexture, disabledTexture: gameCenterDisabledTexture)
        gameCenterButton.size = CGSizeMake(60, 60)
        gameCenterButton.position = playButton.position + CGPointMake(-140, 0)
        gameCenterButton.isEnabled = false
        gameCenterButton.zPosition = 2
        root.addChild(gameCenterButton)
        
        restartButton = GWButton(normalTexture: SKTexture(imageNamed: "icon_restart"))
        restartButton.size = CGSizeMake(60, 60)
        restartButton.position = playButton.position + CGPointMake(0, 140)
        restartButton.zPosition = 2
        root.addChild(restartButton)
        
        super.init()
        
        // some style and callback
        registerEvent()
    }
    
    func registerEvent() {
        
        moodBar.delegate = self
        
        pauseButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click pause")
            self.entity?.componentForClass(UIControlComponent)?.stateMachine?.enterState(UIPauseState)
        })
        
        playButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click play")
            self.entity?.componentForClass(UIControlComponent)?.stateMachine?.enterState(UIPlayingState)
//            self._game.scene.startScreenRecording({ () -> Void in
//                self.entity?.componentForClass(UIControlComponent)?.stateMachine?.enterState(UIPlayingState)
//            })
        })
        
        howButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click how")
            
//            guard let previewViewController = self._game.scene.previewViewController else { fatalError("The user requested playback, but a valid preview controller does not exist.") }
//            
//            guard let rootViewController = self._game.scene.view?.window?.rootViewController else { fatalError("The scene must be contained in a window with e root view controller.") }
//            
//            // `RPPreviewViewController` only supports full screen modal presentation.
//            previewViewController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
//            
//            rootViewController.presentViewController(previewViewController, animated: true, completion:nil)
        })
        
        gameCenterButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click game center")
            
            EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: Constant.leaderboard_id)
        })
        
        restartButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click restart")
            
            
        })
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    func useTitleAppearance() {
        playButton.hidden = false
        gameCenterButton.hidden = false
        howButton.hidden = false
        
        let posA = playButton.position
        playButton.position -= CGPointMake(0, 300)
        let moveUp = SKAction.moveToY(posA.y, duration: 1.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3)
        playButton.runAction(moveUp)
        
        let posB = gameCenterButton.position
        gameCenterButton.position -= CGPointMake(200, 300)
        let moveUpRight = SKAction.moveTo(posB, duration: 1.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.55)
        gameCenterButton.runAction(moveUpRight)
        
        let posC = howButton.position
        howButton.position -= CGPointMake(-200, 300)
        let moveUpLeft = SKAction.moveTo(posC, duration: 1.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.55)
        howButton.runAction(moveUpLeft)
        
        restartButton.hidden = true
        moodBar.hidden = true
        topRoot.hidden = true
        pauseMask.hidden = true
    }
    
    func usePlayingAppearance() {
        logo.hidden = true
        playButton.hidden = true
        gameCenterButton.hidden = true
        howButton.hidden = true
        restartButton.hidden = true
        moodBar.hidden = false
        topRoot.hidden = false
        pauseMask.hidden = true
    }
    
    func usePauseAppearance() {
        playButton.hidden = false
        gameCenterButton.hidden = false
        howButton.hidden = false
        restartButton.hidden = false
        
        let posA = playButton.position
        playButton.position -= CGPointMake(0, 300)
        let moveUp = SKAction.moveToY(posA.y, duration: 1.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3)
        playButton.runAction(moveUp)
        
        let posB = gameCenterButton.position
        gameCenterButton.position -= CGPointMake(200, 300)
        let moveUpRight = SKAction.moveTo(posB, duration: 1.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.55)
        gameCenterButton.runAction(moveUpRight)
        
        let posC = howButton.position
        howButton.position -= CGPointMake(-200, 300)
        let moveUpLeft = SKAction.moveTo(posC, duration: 1.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.55)
        howButton.runAction(moveUpLeft)
        
        let posD = restartButton.position
        restartButton.position -= CGPointMake(0, -300)
        let moveDown = SKAction.moveTo(posD, duration: 1.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.55)
        restartButton.runAction(moveDown)
        
        pauseMask.hidden = false
    }
    
    func useGameOverAppearance() {
        
    }
    
    func onMoodProgressEmpty(bar: MoodBar) {
        _game.worm.comboFail()
    }
    
    func onMoodProgressFull(bar: MoodBar) {
        
    }
}

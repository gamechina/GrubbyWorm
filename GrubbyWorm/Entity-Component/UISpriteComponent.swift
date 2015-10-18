//
//  UISpriteComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/24.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit
import SpriteKit

class UISpriteComponent: GKComponent, MoodBarDelegate, EnergyBarDelegate {
    
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
    
    // recording switch
    var recordSwitch: GWSwitch
    
    // replay button
    var replayButton: GWButton
    
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
        pauseButton = GWButton(normalTexture: SKTexture(imageNamed: "pause"))
        pauseButton.size = CGSizeMake(24, 24)
        pauseButton.position = CGPointMake(sceneSize.width - Theme.energy_bar_margin / 2, Theme.top_bar_board_height / 2)
        
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
        playButton.size = CGSizeMake(100, 100)
        playButton.position = CGPointMake(sceneSize.width / 2, sceneSize.height / 2 - 110)
        playButton.zPosition = 2
        playButton.setRawPosition()
        root.addChild(playButton)
        
        let howNormalTexture = SKTexture(imageNamed: "icon_how")
        howButton = GWButton(normalTexture: howNormalTexture)
        howButton.size = CGSizeMake(50, 50)
        howButton.position = playButton.position + CGPointMake(110, 0)
        howButton.zPosition = 2
        howButton.setRawPosition()
        root.addChild(howButton)
        
        let gameCenterNormalTexture = SKTexture(imageNamed: "icon_game_center_normal")
        let gameCenterDisabledTexture = SKTexture(imageNamed: "icon_game_center_disabled")
        gameCenterButton = GWButton(normalTexture: gameCenterNormalTexture, selectedTexture: gameCenterNormalTexture, disabledTexture: gameCenterDisabledTexture)
        gameCenterButton.size = CGSizeMake(50, 50)
        gameCenterButton.position = playButton.position + CGPointMake(-110, 0)
        gameCenterButton.isEnabled = false
        gameCenterButton.zPosition = 2
        gameCenterButton.setRawPosition()
        root.addChild(gameCenterButton)
        
        restartButton = GWButton(normalTexture: SKTexture(imageNamed: "icon_restart"))
        restartButton.size = CGSizeMake(50, 50)
        restartButton.position = playButton.position + CGPointMake(0, 110)
        restartButton.zPosition = 2
        restartButton.setRawPosition()
        root.addChild(restartButton)
        
        let openSwitch = SKTexture(imageNamed: "icon_record_on")
        let closeSwitch = SKTexture(imageNamed: "icon_record_off")
        recordSwitch = GWSwitch(openTexture: openSwitch, closeTexture: closeSwitch)
        recordSwitch.position = CGPointMake(sceneSize.width - 50, sceneSize.height - 30)
        recordSwitch.zPosition = 2
        recordSwitch.size = CGSizeMake(70, 28)
        root.addChild(recordSwitch)
        
        let recordLabel = SKLabelNode(text: "record")
        recordLabel.fontName = "San Francisco"
        recordLabel.fontColor = SKColor.blackColor()
        recordLabel.name = "record label"
        recordLabel.fontSize = 13
        recordLabel.verticalAlignmentMode = .Center
        recordLabel.position = CGPointMake(7.5, 0)
        recordSwitch.addChild(recordLabel)
        
        replayButton = GWButton(normalTexture: SKTexture(imageNamed: "tip"))
        replayButton.size = CGSizeMake(70, 70)
        replayButton.position = recordSwitch.position - CGPointMake(0, 60)
        replayButton.zPosition = 2
        root.addChild(replayButton)
        
        super.init()
        
        // some style and callback
        registerEvent()
    }
    
    func registerEvent() {
        
        moodBar.delegate = self
        energyBar.delegate = self
        
        pauseButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click pause")
            self.entity?.componentForClass(UIControlComponent)?.stateMachine?.enterState(UIPauseState)
        })
        
        playButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click play")
            
            self.moveOutButtons({ (Void) -> () in
                self.entity?.componentForClass(UIControlComponent)?.stateMachine?.enterState(UIPlayingState)
            })
        })
        
        howButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click how")
        })
        
        gameCenterButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click game center")
            
            EasyGameCenter.showGameCenterAchievements()
        })
        
        restartButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click restart")
            
        })
        
        recordSwitch.onChange = { (sender: GWSwitch) -> Void in
            print("switch change: \(sender.isOpen)")
            
            NSUserDefaults.standardUserDefaults().setValue(sender.isOpen, forKey: Constant.user_data_key_auto_recording)
            
            if !sender.isOpen {
                self._game.scene.discardRecording()
            }
            
            if let recordLabel = self.recordSwitch.childNodeWithName("record label") as? SKLabelNode {
                recordLabel.fontColor = (sender.isOpen ? SKColor.whiteColor() : SKColor.blackColor())
            }
        }
        
        // set record by user default
        recordSwitch.isOpen = NSUserDefaults.standardUserDefaults().boolForKey(Constant.user_data_key_auto_recording)
        
        replayButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click replay")
            
            guard let previewViewController = self._game.scene.previewViewController else { fatalError("The user requested playback, but a valid preview controller does not exist.") }
            
            guard let rootViewController = self._game.scene.view?.window?.rootViewController else { fatalError("The scene must be contained in a window with e root view controller.") }
            
            // `RPPreviewViewController` only supports full screen modal presentation.
            previewViewController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
            
            rootViewController.presentViewController(previewViewController, animated: true, completion:nil)
        })
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    func useTitleAppearance() {
        playButton.hidden = false
        gameCenterButton.hidden = false
        howButton.hidden = false
        recordSwitch.hidden = false
        replayButton.hidden = true
        
        let posA = playButton.getRawPosition()
        playButton.position = posA - CGPointMake(0, 300)
        playButton.quickMoveTo(posA)
        
        let posB = gameCenterButton.getRawPosition()
        gameCenterButton.position = posB - CGPointMake(200, 300)
        gameCenterButton.slowMoveTo(posB)
        
        let posC = howButton.getRawPosition()
        howButton.position = posC - CGPointMake(-200, 300)
        howButton.slowMoveTo(posC)
        
        let triggerTime = (Int64(NSEC_PER_MSEC) * 2000)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.logo.showOutAction()
        })
        
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
        recordSwitch.hidden = true
        replayButton.hidden = true
        moodBar.hidden = false
        topRoot.hidden = false
        pauseMask.hidden = true
    }
    
    func usePauseAppearance() {
        playButton.hidden = false
        gameCenterButton.hidden = false
        howButton.hidden = false
        restartButton.hidden = false
        recordSwitch.hidden = false
        replayButton.hidden = true
        
        let posA = playButton.getRawPosition()
        playButton.position = posA - CGPointMake(0, 300)
        playButton.quickMoveTo(posA)
        
        let posB = gameCenterButton.getRawPosition()
        gameCenterButton.position = posB - CGPointMake(200, 300)
        gameCenterButton.slowMoveTo(posB)
        
        let posC = howButton.getRawPosition()
        howButton.position = posC - CGPointMake(-200, 300)
        howButton.slowMoveTo(posC)
        
        let posD = restartButton.getRawPosition()
        restartButton.position = posD - CGPointMake(0, -300)
        restartButton.slowMoveTo(posD)
        
        pauseMask.hidden = false
    }
    
    func useGameOverAppearance() {
        
    }
    
    func onMoodProgressEmpty(bar: MoodBar) {
        _game.worm?.comboFail()
    }
    
    func onMoodProgressFull(bar: MoodBar) {
        
    }
    
    func onEnergyProgressEmpty(bar: EnergyBar) {
        _game.worm?.happy()
    }
    
    func onEnergyProgressFull(bar: EnergyBar) {
        _game.worm?.crazy()
    }
    
    func moveOutButtons(handler: (Void -> ())) {
        let posLogo = logo.position + CGPointMake(0, 300)
        logo.quickMoveTo(posLogo)
        
        let posA = playButton.position - CGPointMake(0, 300)
        playButton.quickMoveTo(posA)
        
        let posB = gameCenterButton.position - CGPointMake(200, 300)
        gameCenterButton.slowMoveTo(posB)
        
        let posC = howButton.position - CGPointMake(-200, 300)
        howButton.slowMoveTo(posC)
        
        let posD = restartButton.position - CGPointMake(0, -300)
        restartButton.slowMoveTo(posD)
        
        let triggerTime = (Int64(NSEC_PER_MSEC) * 500)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            handler()
        })
    }
}

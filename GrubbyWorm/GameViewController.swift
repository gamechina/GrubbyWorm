//
//  GameViewController.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/13.
//  Copyright (c) 2015年 GAME-CHINA.ORG. All rights reserved.
//

import UIKit
import SpriteKit
import ReplayKit

class GameViewController: UIViewController, EasyGameCenterDelegate {
    
    var game: Game?
    
    weak var previewControllerDelegate: RPPreviewViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsDrawCount = true
        skView.showsFields = true
        skView.showsQuadCount = true
        
        game = Game(view: skView)
        
        skView.presentScene(game?.scene)
        
        /*** Set Delegate UIViewController ***/
        EasyGameCenter.sharedInstance(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*** Set View Controller delegate, that's when you change UIViewController ***/
        EasyGameCenter.delegate = self
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            return .AllButUpsideDown
//        } else {
//            return .All
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func easyGameCenterAuthentified() {
        if let uiSprite = game?.ui.componentForClass(UISpriteComponent) {
            uiSprite.gameCenterButton.isEnabled = true
        }
    }
}

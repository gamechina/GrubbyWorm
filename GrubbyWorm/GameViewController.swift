//
//  GameViewController.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/13.
//  Copyright (c) 2015年 GAME-CHINA.ORG. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var game: Game?

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
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func swipeUp(sender: UISwipeGestureRecognizer) {
        print("up")
        if let wormSprite = game?.worm.componentForClass(WormSpriteComponent) {
            wormSprite.turn(.Up)
        }
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        print("right")
        if let wormSprite = game?.worm.componentForClass(WormSpriteComponent) {
            wormSprite.turn(.Right)
        }
    }
    
    @IBAction func swipeDown(sender: UISwipeGestureRecognizer) {
        print("down")
        if let wormSprite = game?.worm.componentForClass(WormSpriteComponent) {
            wormSprite.turn(.Down)
        }
    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        print("left")
        if let wormSprite = game?.worm.componentForClass(WormSpriteComponent) {
            wormSprite.turn(.Left)
        }
    }
    
    
}

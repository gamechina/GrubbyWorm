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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SKScene()
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        scene.backgroundColor = AppTheme.scene_background_color
        
        skView.presentScene(scene)
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
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        print("right")
    }
    
    @IBAction func swipeDown(sender: UISwipeGestureRecognizer) {
        print("down")
    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        print("left")
    }
    
    
}

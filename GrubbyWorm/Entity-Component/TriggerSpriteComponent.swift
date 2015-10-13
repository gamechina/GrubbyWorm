//
//  TriggerSpriteComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/7.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit
import SpriteKit

// MARK: Trigger Type

enum TriggerType {
    case Sugar
    case Candy
    case Grubby
}

// MARK: Trigger Sugar Style

enum TriggerSugarStyle {
    case Maltose
    case Praline
    case Fondant
    case Crispy
    case Chocolate
}

class TriggerSpriteComponent: GKComponent {
    
    static let triggerSize = CGSizeMake(36, 36)
    
    // MARK: Properties
    
    var root: SKNode
    var type: TriggerType
    var style: TriggerSugarStyle?
    
    // MARK: Initializers

    init(type: TriggerType = .Sugar, style: TriggerSugarStyle = .Maltose) {
        root = SKNode()
        self.type = type
        
        if type == .Sugar {
            self.style = style
        }
        
        super.init()
        
        giveBirth()
    }
    
    private func giveBirth() {
        switch type {
        case .Sugar, .Candy:
            sugarBorn({ (Void) -> () in
                self.renderDisplay()
            })
            break
        case .Grubby:
            renderDisplay()
            break
        }
    }
    
    private func renderDisplay() {
        
        let size = TriggerSpriteComponent.triggerSize
        
        switch type {
        case .Sugar:
            let display = SKSpriteNode(imageNamed: "sugar")
            display.size = size
            
            renderSugarStyle(display)
            sugarRotate(display)
            
            root.addChild(display)
            break
        case .Candy:
            let display = SKSpriteNode(imageNamed: "big_sugar")
            display.size = size
            
            sugarRotate(display)
            
            root.addChild(display)
            break
        case .Grubby:
            let display = SKSpriteNode(imageNamed: "bb")
            display.size = size
            display.setScale(0.8)
            display.position = CGPointMake(0, -8)
            
            grubbySmell(display)
            
            root.addChild(display)
            break
        }
    }
    
    private func renderSugarStyle(display: SKSpriteNode) {
        if let style = style {
            switch style {
            case .Maltose:
                display.color = SKColor.blueColor()
                display.colorBlendFactor = 0.6
                
                break
            case .Praline:
                display.color = Theme.temp_color
                display.colorBlendFactor = 0.5
                
                break
            case .Fondant:
                display.color = SKColor.grayColor()
                display.colorBlendFactor = 0.8
                
                break
            case .Crispy:
                break
            case .Chocolate:
                break
            }
        }
    }
    
    private func sugarRotate(display: SKSpriteNode) {
        let action = SKAction.rotateByAngle(5, duration: 5.0)
        display.runAction(SKAction.repeatActionForever(action))
    }
    
    private func grubbySmell(display: SKSpriteNode) {
        let smell = SKSpriteNode(imageNamed: "smell")
        smell.size = display.size
        smell.position = CGPointMake(0, 25)
        smell.zPosition = 1
        smell.setScale(0.7)
        display.addChild(smell)
        
//        let fadeOut = SKAction.fadeOutWithDuration(1.8, delay: 5, usingSpringWithDamping: 1, initialSpringVelocity: 1)
        let moveUp = SKAction.moveToY(50, duration: 2.4)
//        let action = SKAction.sequence([fadeOut, moveUp])
        
        smell.runAction(SKAction.repeatActionForever(moveUp))
    }
    
    private func sugarBorn(handler: (Void -> ())) {
        let born = SKSpriteNode(imageNamed: "somite")
        born.size = TriggerSpriteComponent.triggerSize
        born.setScale(0.5)
        root.addChild(born)
        
        let scale = SKAction.scaleXTo(0.8, y: 0.8,
            duration: 2.0, delay: 0,
            usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
        
        born.runAction(scale) { () -> Void in
            born.removeFromParent()

            if let entity = self.entity as? TriggerEntity {
                entity.born = true
                handler()
            }
        }
    }
}

//
//  WormDigestiveComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/13.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit
import SpriteKit

class WormDigestiveComponent: GKComponent {

    weak var game: Game?
    
    var wantEat: [TriggerSugarStyle]
    
    var shitCount = 0 {
        didSet {
            if shitCount < 0 {
                shitCount = 0
            }
        }
    }
    
    init(game: Game?) {
        self.game = game
        self.wantEat = [.Maltose, .Praline, .Fondant, .Crispy, .Chocolate]
        
        super.init()
    }
    
    func haveShit() -> Bool {
        return shitCount != 0
    }
    
    func eat(trigger: TriggerEntity) {
        _digest(trigger)
        
        // if state is happy
        if let stateMachine = entity?.componentForClass(WormControlComponent)?.stateMachine {
            if stateMachine.currentState == stateMachine.stateForClass(WormHappyState) {
                
                switch trigger.type() {
                case .Sugar:
                    let firstWantEat = wantEatNow()
                    if let sugarSprite = trigger.componentForClass(TriggerSpriteComponent) {
                        if sugarSprite.style == firstWantEat {
                            shitCount++
                            
                            addWantEat()
                        } else {
                            stomachache()
                        }
                    }
                    break
                case .Candy:
                    shitCount += 5
                    break
                case .Grubby:
                    stomachache()
                    break
                }
            }
        }
    }
    
    private func _digest(trigger: TriggerEntity) {
        
        if let stateMachine = entity?.componentForClass(WormControlComponent)?.stateMachine {
            if stateMachine.currentState == stateMachine.stateForClass(WormCrazyState) {
                return
            }
        }
        
        if let energyInfo = game?.energy {
            
            var info = energyInfo
            info.round = energyInfo.round
            
            if energyInfo.current + trigger.energy >= energyInfo.total {
                info.current = energyInfo.total
                info.round++
                
                if let stateMachine = entity?.componentForClass(WormControlComponent)?.stateMachine {
                    stateMachine.enterState(WormCrazyState)
                }
                
            } else {
                info.current += trigger.energy
            }
            
            game?.energy = info
        }
    }
    
    func shit() {
        if let worm = entity as? WormEntity {
            let grubby = GrubbyTriggerEntity(location: worm.tailLocation())
            if let game = game {
                if game.addTrigger(grubby) {
                    shitCount--
                }
            }
            
            if let wormSprite = worm.componentForClass(WormSpriteComponent) {
                wormSprite.root.runAction(SKAction.playSoundFileNamed("shit.wav", waitForCompletion: false))
            }
        }
    }
    
    func stomachache() {
        if let stateMachine = entity?.componentForClass(WormControlComponent)?.stateMachine {
            stateMachine.enterState(WormDefeatedState)
        }
    }
    
    func wantEatNow() -> TriggerSugarStyle {
        return wantEat[0]
    }
    
    func addWantEat() {
        wantEat.removeFirst()
        wantEat.append(TriggerSugarStyle.randomStyle())
        
        if let wormSprite = entity?.componentForClass(WormSpriteComponent) {
            wormSprite.renderSomitesStyle()
        }
    }
}

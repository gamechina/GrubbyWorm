//
//  WormSpriteComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/7.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit
import SpriteKit

class WormSpriteComponent: GKComponent {
    
    private var _game: Game
    private var _ui: Entity?
    
    var playground: Playground?
    var root: SKNode
    var direction: Direction
    var somites: [SKSpriteNode]
    var locations: [Location]
    var delta: NSTimeInterval
    
    init(game: Game, ui: Entity?) {
        self._game = game
        self._ui = ui
        
        playground = game.level.playground
        
        root = SKNode()
        direction = .Right
        somites = []
        locations = []
        delta = 0
        
        super.init()
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        if let controlComponent = _ui?.componentForClass(UIControlComponent) {
            if let state = controlComponent.stateMachine?.currentState {
                if controlComponent.stateMachine?.stateForClass(UIPlayingState) == state {
                    
                    delta += seconds
                    
                    if let worm = entity as? WormEntity {
                        if delta >= worm.info.speed {
                            doCrawl()
                        }
                    }
                }
            }
        }
    }
    
    func renderSomites() {
        let size = CGSizeMake(36, 36)
        
        if let worm = entity as? WormEntity {
            for _ in 0..<worm.info.foot {
                let node = SKSpriteNode(imageNamed: "somite")
                node.size = size
                node.color = Theme.temp_color
                node.colorBlendFactor = 1
                root.addChild(node)
                somites.append(node)
            }
        }
        
        renderSomitesStyle()
    }
    
    func renderSomitesStyle() {
        if let digest = entity?.componentForClass(WormDigestiveComponent) {
            if let worm = entity as? WormEntity {
                if digest.wantEat.count == worm.info.foot {
                    for i in 0..<digest.wantEat.count {
                        somites[i].color = digest.wantEat[i].color()
                    }
                }
            }
        }
    }
    
    func renderNodesPosition() {
        if let worm = entity as? WormEntity {
            for i in 0..<worm.info.foot {
                if let tile = playground?.tileByLocation(locations[i]) {
                    
                    // interesting
//                    somites[i].removeActionForKey("crawl")
//                    let to = SKAction.moveTo(tile.position, duration: worm.info.speed)
//                    somites[i].runAction(to, withKey: "crawl")
                    
                    somites[i].position = tile.position
                }
            }
        }
    }
    
    func getNextLocation(now: Location) -> Location {
        if let range = playground?.getGridSizeRange() {
            switch direction {
            case .Right:
                return now.right(range)
            case .Left:
                return now.left(range)
            case .Down:
                return now.down(range)
            case .Up:
                return now.up(range)
            }
        } else {
            switch direction {
            case .Right:
                return now.right()
            case .Left:
                return now.left()
            case .Down:
                return now.down()
            case .Up:
                return now.up()
            }
        }
    }
    
    func initLocations(location: Location) {
        locations.append(location)
        locations.append(location.left())
        locations.append(location.left().down())
        locations.append(location.left().down().down())
        locations.append(location.left().down().down().left())
        
        renderNodesPosition()
    }
    
    func doCrawl() {
        delta = 0
        
        var loc = [Location]()
        loc.append(getNextLocation(locations[0]))
        
        if let worm = entity as? WormEntity {
            for i in 1..<worm.info.foot {
                loc.append(locations[i - 1])
            }
        }
        
        // shit
        if let worm = entity as? WormEntity {
            worm.shit()
        }
        
        locations = loc
        renderNodesPosition()
        
        // make playground focus the worm
        playground!.focusWorm()
    }
    
    func turn(target: Direction) {
        if let controlComponent = _ui?.componentForClass(UIControlComponent) {
            if let state = controlComponent.stateMachine?.currentState {
                if controlComponent.stateMachine?.stateForClass(UIPlayingState) == state {
                    
                    if direction == target.refect() {
                        return
                    }
                    
                    if direction == target {
                        return
                    }
                    
                    direction = target
                    doCrawl()
                }
            }
        }
    }
    
    func useCrazyAppearance() {
        _game.scene.backgroundColor = Theme.primary_color
        
        for i in 0..<somites.count {
            somites[i].color = SKColor.whiteColor()
            somites[i].colorBlendFactor = 1
        }
        
        if let tiles = playground?.tiles {
            for i in 0..<tiles.count {
                tiles[i].renderCrazyTile()
            }
        }
    }
    
    func useNormalAppearance() {
        _game.scene.backgroundColor = Theme.scene_background_color
        
        renderSomitesStyle()
        
        if let tiles = playground?.tiles {
            for i in 0..<tiles.count {
                tiles[i].renderStyle()
            }
        }
    }
}

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
    var info: WormInfo
    var direction: Direction
    var somites: [SKSpriteNode]
    var locations: [Location]
    var delta: NSTimeInterval
    
    init(game: Game, ui: Entity?) {
        self._game = game
        self._ui = ui
        
        playground = game.level.playground
        
        root = SKNode()
        info = WormInfo(name: "Grubby Worm", speed: 0.1, foot: 5, type: .Grubby)
        direction = .Right
        somites = []
        locations = []
        delta = 0
        
        super.init()
        
        renderWorm()
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        delta += seconds
        
        if delta >= info.speed {
            delta = 0
            doCrawl()
        }
    }
    
    func renderWorm() {
        let size = CGSizeMake(36, 36)
        for _ in 0..<info.foot {
            let node = SKSpriteNode(color: Theme.temp_color, size: size)
            root.addChild(node)
            somites.append(node)
        }
    }
    
    func renderNodesPosition() {
        for i in 0..<info.foot {
            if let tile = playground?.tileByLocation(locations[i]) {
                somites[i].position = tile.position
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
        var loc = [Location]()
        loc.append(getNextLocation(locations[0]))
        
        for i in 1..<info.foot {
            loc.append(locations[i - 1])
        }
        
        locations = loc
        renderNodesPosition()
    }
}

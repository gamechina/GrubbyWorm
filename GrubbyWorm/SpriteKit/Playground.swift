//
//  Playground.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/7.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

class Playground: SKNode {
    
    let focusMoveActionKey = "focusMove"
    
    let gridSize = GridSize(row: 30, col: 30)
    
    var size: CGSize
    var tiles: [Tile]
    var contentSize: CGSize
    
    weak var worm: WormEntity?
    
    init(size: CGSize) {
        self.size = size
        tiles = []
        contentSize = CGSizeZero
        
        super.init()
        
        renderGrid()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getGridSizeRange() -> GridSizeRange {
        let from = GridSize(row: Int(-gridSize.row / 2), col: Int(-gridSize.col / 2))
        let to = GridSize(row: from.row + gridSize.row - 1, col: from.col + gridSize.col - 1)
        
        return GridSizeRange(from: from, to: to)
    }
    
    func renderGrid() {
        removeAllChildren()
        tiles.removeAll()
        
        let range = getGridSizeRange()
        
        for i in range.from.row...range.to.row {
            for j in range.from.col...range.to.col {
                let style: TileStyle = ((i + j) % 2 == 0) ? .Normal : .Marble
                let tile = Tile(location: GridSize(row: i, col: j), style: style)
                
                let posX = (Theme.tile_interval + tile.size.width) * (CGFloat(i) + 0.5)
                let posY = (Theme.tile_interval + tile.size.height) * (CGFloat(j) + 0.5)
                
//                tile.renderLocation()
                tile.position = CGPointMake(posX, posY)
                
                addChild(tile)
                tiles.append(tile)
            }
        }
        
        // content size
        contentSize.width = (Theme.tile_interval + 38) * CGFloat(gridSize.row) + Theme.tile_interval
        contentSize.height = (Theme.tile_interval + 38) * CGFloat(gridSize.col) + Theme.tile_interval
    }
    
    func tileByLocation(location: Location) -> Tile? {
        var ret: Tile?
        
        for tile in tiles {
            if tile.location.row == location.row && tile.location.col == location.col {
                ret = tile
                break
            }
        }
        
        return ret
    }
    
    func addWorm(worm: WormEntity, location: Location) {
        self.worm = worm
        
        if let wormSprite = worm.componentForClass(WormSpriteComponent) {
            wormSprite.playground = self
            wormSprite.renderSomites()
            wormSprite.initLocations(location)
            addChild(wormSprite.root)
        }
    }
    
    func addTrigger(trigger: TriggerEntity) -> Bool {
        if let tile = tileByLocation(trigger.location) {
            if !tile.hasTrigger {
                if let triggerSprite = trigger.componentForClass(TriggerSpriteComponent) {
                    tile.addChild(triggerSprite.root)
                    tile.hasTrigger = true
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func focusWorm() {
        if let wormSprite = worm?.componentForClass(WormSpriteComponent) {
            let loc = wormSprite.somites[0].position
            self.removeActionForKey(focusMoveActionKey)
            
            let center = CGPointMake(size.width / 2, size.height / 2)

            var moveTo = CGPointMake(-loc.x, -loc.y) + center
            
            if moveTo.x < 88 {
                moveTo.x = 88
            }
            
            if moveTo.x > 580 {
                moveTo.x = 580
            }
            
            if moveTo.y < -238 {
                moveTo.y = -238
            }
            
            if moveTo.y > 584 {
                moveTo.y = 584
            }
            
//            print(moveTo)
            
            let action = SKAction.moveTo(moveTo, duration: worm!.info.speed)
            self.runAction(action, withKey: focusMoveActionKey)
        }
    }
    
    func playSound() {
        
        // play sound
        let sound = SKAction.playSoundFileNamed(Constant.background_sound, waitForCompletion: true)
        runAction(SKAction.repeatActionForever(sound))
    }
}

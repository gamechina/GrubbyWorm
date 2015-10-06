//
//  Playground.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/7.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

class Playground: SKNode {
    
    let gridSize = GridSize(row: 32, col: 32)
    
    var size: CGSize
    var tiles: [Tile]
    
    init(size: CGSize) {
        self.size = size
        self.tiles = []
        
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
                
                tile.position = CGPointMake(posX, posY)
                
                addChild(tile)
                tiles.append(tile)
            }
        }
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
}

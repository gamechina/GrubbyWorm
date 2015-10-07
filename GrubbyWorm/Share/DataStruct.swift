//
//  DataStruct.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/8/13.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import SpriteKit

enum Direction {
    case Left
    case Right
    case Down
    case Up
    
    func refect() -> Direction {
        switch self {
        case .Right:
            return .Left
        case .Down:
            return .Up
        case .Left:
            return .Right
        case .Up:
            return .Down
        }
    }
}

struct Location {
    var row: Int = 0
    var col: Int = 0
    
    func up() -> Location {
        return Location(row: self.row, col: self.col + 1)
    }
    
    func down() -> Location {
        return Location(row: self.row, col: self.col - 1)
    }
    
    func left() -> Location {
        return Location(row: self.row - 1, col: self.col)
    }
    
    func right() -> Location {
        return Location(row: self.row + 1, col: self.col)
    }
    
    func up(inRange: GridSizeRange) -> Location {
        if self.col == inRange.to.col {
            return Location(row: self.row, col: inRange.from.col)
        } else {
            return self.up()
        }
    }
    
    func down(inRange: GridSizeRange) -> Location {
        if self.col == inRange.from.col {
            return Location(row: self.row, col: inRange.to.col)
        } else {
            return self.down()
        }
    }
    
    func left(inRange: GridSizeRange) -> Location {
        if self.row == inRange.from.row {
            return Location(row: inRange.to.row, col: self.col)
        } else {
            return self.left()
        }
    }
    
    func right(inRange: GridSizeRange) -> Location {
        if self.row == inRange.to.row {
            return Location(row: inRange.from.row, col: self.col)
        } else {
            return self.right()
        }
    }
}

typealias GridSize = Location

struct GridSizeRange {
    var from: GridSize
    var to: GridSize
}

enum WormType {
    case Normal
    case Grubby
}

struct WormInfo {
    var name: String?
    var speed: NSTimeInterval
    var foot: Int
    var type: WormType
}
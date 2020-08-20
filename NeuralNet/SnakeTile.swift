//
//  SnakeTile.swift
//  NeuralNet
//
//  Created by Maya Luna Celeste on 8/5/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

import Cocoa

class SnakeTile: NSObject, NSCopying {
    enum TileType : Int {
        case empty = 0
        case head = 1
        case body = 2
        case food = 3
    }
    
    var tileType : TileType = TileType.empty
    var age : Int = 0
    var position : NSPoint = NSPoint()
    var next : SnakeTile!
    weak var previous : SnakeTile!
    
    func copy(with zone: NSZone? = nil) -> Any {
        var copy = SnakeTile()
        copy.age = age
        copy.tileType = tileType
        copy.position = position
        
        if next != nil {
            copy.next = next.copy() as? SnakeTile
            copy.next.previous = copy
        }
        
        return copy
    }
}

//
//  SnakeAdapter.swift
//  NeuralNet
//
//  Created by Maya Luna Celeste on 8/5/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

import Cocoa

class SnakeAdapter: NSObject {
    
    var netOuts : [Double] = [0,0,0,0]
    
    enum SnakeMove : Int {
        case up = 0
        case down = 1
        case left = 2
        case right = 3
        case error = 4
    }
    
    init(network : Network) {
        netOuts = network.outs
    }
    
    func moveType() -> SnakeMove {
        if netOuts.count != 4 { return SnakeMove.error }
        var val : Int = 0
        for i in 0 ..< netOuts.count { if netOuts[i] > netOuts[val] { val = i } }
        return SnakeMove(rawValue: val) ?? SnakeMove.error
    }
    
}

//
//  Connection.swift
//  NeuralNet
//
//  Created by Maya Luna Celeste on 7/6/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

import Foundation

class Connection : NSObject, NSCopying {
    
    var weight : Double!
    var parentNode : Neuron!
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy : Connection = Connection()
        return copy
    }
    
    func simulate() -> Double {
        return weight * parentNode.doubleValue
    }
    
    func setParent(newParent : Neuron) {
        parentNode = newParent
    }
    
    func randomizeWeight(variance : Double = 2) {
        weight = (Double(Double(arc4random()) / Double(UINT32_MAX)) * variance - (variance / 2))
    }
    
    func configure(newParent : Neuron, newWeight : Double) {
        parentNode = newParent
        weight = newWeight
    }
    
}

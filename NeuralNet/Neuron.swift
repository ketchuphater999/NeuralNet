//
//  Neuron.swift
//  NeuralNet
//
//  Created by Maya Luna Celeste on 7/6/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

import Foundation
import GameplayKit

class Neuron : NSObject, NSCopying {
    
    var connections : [Connection] = []
    var doubleValue : Double = 0.0
    var bias : Double = 0.0
    var useSigmoid : Bool = false
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy : Neuron = Neuron()
        copy.bias = bias
        copy.doubleValue = doubleValue
        for connection in connections { copy.connections.append(connection) }
        return copy
    }
    
    func configure(newConnections : [Connection]) {
        connections = newConnections
    }
    
    func addConnections(newConnections : [Connection]) {
        connections.append(contentsOf: newConnections)
    }
    
    func randomizeBias(variance : Double = 2) {
        bias = (Double(Double(arc4random()) / Double(UINT32_MAX)) * variance - (variance / 2))
    }
    
    func randomizeConnections(variance : Double = 2) {
        for connection in connections {
            
            connection.weight = (Double(Double(arc4random()) / Double(UINT32_MAX)) * variance - (variance / 2))
            
        }
    }
    
    func runConnections() -> Bool {
        if self.connections.count == 0 {
            return false
        }
        
        //sum all the connection values
        doubleValue = 0.0
        for connection in self.connections {
            doubleValue += connection.simulate()
        }
        
        
        //if useSigmoid is true, run the sigmoid function on the ending value, then apply bias
        if useSigmoid {
            doubleValue = sigmoid(doubleValue) + bias
        } else {
            doubleValue += bias
        }
        
        return true
    }
    
}

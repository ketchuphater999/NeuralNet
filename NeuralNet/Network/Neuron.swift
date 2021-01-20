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
        //set the bias value to a random number within the given range
        
        bias = (Double(Double(arc4random()) / Double(UINT32_MAX)) * variance - (variance / 2))
    }
    
    func randomizeConnections(variance : Double = 2) {
        //set each connection's weight to a random number within the given range
        
        for connection in connections {
            connection.weight = (Double(Double(arc4random()) / Double(UINT32_MAX)) * variance - (variance / 2))
        }
    }
    
    func runConnections() -> Bool {
        //simulate all connections belonging to the neuron, then update the neuron's value
        
        var newValue : Double = 0.0
        
        if self.connections.count == 0 {
            return false
        }
        
        //sum all the connection values
        for connection in self.connections {
            newValue += connection.simulate()
        }
        
        
        //if useSigmoid is true, run the sigmoid function on the ending value, then apply bias
        if useSigmoid {
            newValue = sigmoid(doubleValue) + bias
        } else {
            newValue += bias
        }
        
        //update the neuron's value
        doubleValue = newValue
        
        return true
    }
    
}

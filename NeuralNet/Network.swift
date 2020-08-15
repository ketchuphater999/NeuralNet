//
//  Network.swift
//  NeuralNet
//
//  Created by Maya Luna Celeste on 7/6/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

import Foundation

class Network : NSObject, NSCopying {
    
    var network : [[Neuron]] = [[]]
    var outs : [Double] = []
    var layersCount : Int = 0
    var nodesPerLayer : [Int] = []
    var score : Double = 0
    var useBias : Bool = false
    var replay : [Any]!
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copyOfNetwork : Network = Network()
        
        copyOfNetwork.configure(layers: layersCount, nodes: nodesPerLayer)
        for i in 0..<copyOfNetwork.network.count {
            for j in 0..<network[i].count {
                for k in 0..<network[i][j].connections.count {
                    copyOfNetwork.network[i][j].connections[k].weight = network[i][j].connections[k].weight
                }
                copyOfNetwork.network[i][j].bias = network[i][j].bias
            }
        }
        copyOfNetwork.useBias = useBias
        
        return copyOfNetwork
    }
    
    func configure(layers : Int, nodes : [Int]) {
        network = []
        layersCount = layers
        nodesPerLayer = nodes
        
        //populate the network array
        for i in 0...layers-1 {
            network.append([])
            
            for _ in 0...nodes[i]-1 {
                let neuron : Neuron = Neuron()
                
                if i > 0 {
                    var connections : [Connection] = []
                    
                    for parent in network[i-1] {
                        let connection : Connection = Connection()
                        connection.configure(newParent: parent, newWeight: 0.0)
                        connections.append(connection)
                    }
                    neuron.configure(newConnections: connections)
                }
                network[i].append(neuron)
            }
        }
    }
    
    func randomize(weightVariance : Double, biasVariance : Double) {
        
        for layer in network {
            for neuron in layer {
                neuron.randomizeBias(variance: biasVariance)
                neuron.randomizeConnections(variance: weightVariance)
            }
        }
        
        if biasVariance != 0 {
            useBias = true
        }
        
    }
    
    func run(inputs : [Double]) -> [Double] {
        
        assert(inputs.count == network[0].count, "incorrect number of inputs")
        
        //set the input values
        for i in 0...inputs.count-1 { network[0][i].doubleValue = inputs[i] }
        
        //run all connections in the network
        for layer in network {
            for neuron in layer {
                neuron.runConnections()
            }
        }
        
        //create and return an array containing output values
        outs = []
        for neuron in network.last! {
            outs.append(neuron.doubleValue)
        }
        return outs
    }
    
    func mutate(mutationRate : Double) {
        
        for layer in network {
            for neuron in layer {
                for connection in neuron.connections {
                    //mutate each connection weight by a random value, ensuring it stays between -1 and 1
                    let chance = drand48()
                    if chance < mutationRate {
                        connection.weight += gaussRand(0,1)/5
                        if connection.weight > 1 {
                            connection.weight = 1
                        } else if connection.weight < -1 {
                            connection.weight = -1
                        }
                    }
                }
                
                //do the same with each bias value
                let chance = drand48()
                if chance < mutationRate {
                    neuron.bias += gaussRand(0,1)/5
                    if neuron.bias > 1 {
                        neuron.bias = 1
                    } else if neuron.bias < -1 {
                        neuron.bias = -1
                    }
                }
            }
        }
        
    }
    
    func networkByMutating(mutationRate : Double) -> Network {
        let mutated : Network = copy() as! Network
        mutated.mutate(mutationRate: mutationRate)
        return mutated
    }
    
    func networkByCrossing(partner : Network) -> Network {
        //creates a new network using a combination of weights and biases from each parent network.
        let child : Network = copy() as! Network
        
        assert(nodesPerLayer.elementsEqual(partner.nodesPerLayer), "Network topologies do not match.")
        
        for i in 0...child.network.count-1 {
            let totalConnections = child.network[i][0].connections.count * child.network[i].count
            var connectionCount = 0
            var neuronCount = 0
            let weightThreshold = drand48() * Double(totalConnections)
            let biasThreshold =  drand48() * Double(child.network[i].count)
            print("weight threshold: \(weightThreshold)\nbias threshold: \(biasThreshold)")
            for j in 0...child.network[i].count-1 {
                neuronCount += 1
                if i > 0 {
                    for k in 0...child.network[i][j].connections.count-1 {
                        connectionCount += 1
                        if Double(connectionCount) > weightThreshold {
                            child.network[i][j].connections[k].weight = partner.network[i][j].connections[k].weight
                        }
                    }
                }
                if Double(neuronCount) > biasThreshold {
                    child.network[i][j].bias = partner.network[i][j].bias
                }
            }
        }
        return child
    }
    
    func generateModel() -> NSArray {
        //convert the network array into an array of dictionaries containing double values for each neuron and connection, so that it can be imported or saved to a file
        let model : NSMutableArray = []
        for layer in network {
            let modelLayer : NSMutableArray = []
            for neuron in layer {
                let modelNeuron : NSMutableDictionary = [:]
                let modelConnections : NSMutableArray = []
                for connection in neuron.connections {
                    modelConnections.add(connection.weight!)
                }
                
                modelNeuron[NSString.init(string: "bias")] = neuron.bias
                modelNeuron[NSString.init(string: "connections")] = modelConnections
                modelLayer.add(modelNeuron)
            }
            model.add(modelLayer)
        }
        return model
    }
    
    func importModel(model : [[Any]]) {
        //uses the imported weight and bias values to generate a new network array
        let layers = model.count
        var nodesPerLayer : [Int] = []
        
        for layer : [Any] in model {
            nodesPerLayer.append(layer.count)
        }
        
        configure(layers: layers, nodes: nodesPerLayer)
        
        for i in 0...self.network.count-1 {
            var modelLayer = model[i]
            var layer = network[i]
            for j in 0...layer.count-1 {
                var modelNeuron = modelLayer[j] as! [String : Any]
                let neuron = layer[j]
                if i > 0 {
                    for k in 0...neuron.connections.count-1 {
                        let connections = modelNeuron["connections"] as! [Double]
                        neuron.connections[k].weight = connections[k]
                    }
                }
                neuron.bias = modelNeuron["bias"] as! Double
            }
        }
    }
}

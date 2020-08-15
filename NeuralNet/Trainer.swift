//
//  Trainer.swift
//  NeuralNet
//
//  Created by Maya Luna Celeste on 8/12/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

import Cocoa

class Trainer: NSObject {
    
    @IBOutlet weak var snakeView : SnakeView!
    @IBOutlet weak var genView : NSTextField!
    @IBOutlet weak var progressLabel : NSTextField!
    @IBOutlet weak var progressBar : NSProgressIndicator!
    var shouldRun : Bool = false
    var snakeGame : SnakeGame!
    var networks : [Network] = []
    var outputs : [Double] = []
    var currentGen : Int = 0
    
    let queue = DispatchQueue(label: "com.maya.neural-net")

    @IBAction func newRun(_ sender: Any) {
        networks = []
        //populate the array with randomized networks
        for _ in 1...1000 {
            let net = Network()
            net.configure(layers: 4, nodes: [24,16,16,4])
            net.randomize(weightVariance: 2, biasVariance: 0)
            networks.append(net)
        }
    }
    
    @IBAction func nextGen(_ sender: Any) {
        queue.async {
            self.nextGen()
            self.repopulate(range:100, mutationRate: 0.05)
        }
    }
    
    func nextGen() {
        self.currentGen += 1
        DispatchQueue.main.async {
            self.genView.stringValue = "Gen: \(self.currentGen)"
            
            self.progressLabel.isHidden = false
            self.progressLabel.stringValue = "Simulating networks..."
            self.progressBar.minValue = 0
            self.progressBar.maxValue = Double(self.networks.count)
            self.progressBar.isHidden = false
            self.progressBar.doubleValue = 0
            self.progressBar.display()
        }
        var count = 1
        let game = SnakeGame()
        
        for net in networks {
            //update progress bar
            DispatchQueue.main.async {
                self.progressBar.increment(by: 1)
                self.progressBar.display()
            }
            
            //run each network in the array, saving its final score to the score property of the network.
            print("running net \(count)")
            game.configure(height: 15, width: 15)
            while game.gameActive {
                let inputs = game.inputs()
                net.run(inputs: inputs)
                let adapter = SnakeAdapter(network: net)
                game.run(with: adapter.moveType())
            }
            net.score = game.fitness()
            net.replay = game.replay
            count += 1
        }
        networks = sortNets(unsortedArray: networks)!
        networks.reverse()
        print("best score:\(networks[0].score)")
    }
    
    
    @IBAction func bestNet(_ sender: Any) {
        //run the replay of the first network in the sorted array
        let net = networks[0]
        let game = SnakeGame()
        game.configure(height: 15, width: 15, view: snakeView)
        queue.async {
            game.runReplay(net.replay as! [[String : SnakeTile]])
        }
    }
    
    func repopulate(range: Int, mutationRate: Double) {
        // use the the networks within [range] to repopulate the array by crossing and then mutating
        var newNets : [Network] = []
        var bestNets : [Network] = Array(networks[0..<range])
        let total = networks.count
        
        DispatchQueue.main.async {
            self.progressLabel.stringValue = "Repopulating..."
            self.progressBar.doubleValue = 0
            self.progressBar.minValue = 0
            self.progressBar.maxValue = Double(total)
            self.progressBar.display()
        }
        
        while newNets.count < total {
            DispatchQueue.main.async {
                self.progressBar.doubleValue = Double(newNets.count)
                self.progressBar.display()
            }
            
            let parent1 = Int(arc4random_uniform(UInt32(range)))
            var parent2 = Int(arc4random_uniform(UInt32(range)))
            while parent1 == parent2 {
                parent2 = Int(arc4random_uniform(UInt32(range)))
            }
            let newNet = bestNets[parent1].networkByCrossing(partner: bestNets[parent2])
            newNet.mutate(mutationRate: mutationRate)
            newNets.append(newNet)
        }
        networks = newNets
        
        DispatchQueue.main.async {
            self.progressLabel.isHidden = true
            self.progressBar.isHidden = true
        }
    }
    
    @IBAction func begin(_ sender: Any) {
        shouldRun = true
        queue.async {
            while self.shouldRun {
                autoreleasepool {
                    if self.currentGen == 0 {
                        self.nextGen()
                    }
                    self.repopulate(range:100, mutationRate: 0.05)
                    self.nextGen()
                }
            }
        }
    }
    
    @IBAction func end(_ sender: Any) {
        shouldRun = false
    }
    
    @IBAction func save(_ sender: Any) {
        //convert the best network in the array to a property list of all its weights and biases, then save it to a file
        let panel = NSSavePanel()
        let model = networks[0].generateModel()
        panel.canCreateDirectories = true
        panel.showsTagField = false
        let label = "\(arc4random_uniform(999999)).plist"
        panel.nameFieldStringValue = label
        panel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        panel.begin(completionHandler: { (result) in
            if result == NSApplication.ModalResponse.OK {
                let data = try! PropertyListSerialization.data(fromPropertyList: model, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
                try! data.write(to: panel.url!)
            }
        })
    }
    
    @IBAction func open(_ sender: Any) {
        //load a property list from a .plist file, and import it into a new network.
        let panel = NSOpenPanel()
        let network = Network()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.begin(completionHandler: { (result) in
            if result == NSApplication.ModalResponse.OK {
                let modelURL = panel.url
                let data = try! Data.init(contentsOf: modelURL!)
                let model = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil)
                network.importModel(model: model as! [[Any]])
                
                let game = SnakeGame()
                game.configure(height: 15, width: 15, view: self.snakeView)
                self.queue.async {
                    while game.gameActive {
                        let inputs = game.inputs()
                        network.run(inputs: inputs)
                        let adapter = SnakeAdapter(network: network)
                        game.run(with: adapter.moveType())
                        usleep(20000)
                    }
                }
            }
        })
    }

    func sortNets(unsortedArray: [Network]) -> [Network]?{
        //sort networks by score, highest first.
        var sortedArray = unsortedArray
        if sortedArray.count < 2 { return nil }
        for j in 0...sortedArray.count-1 {
            var i = j
            while(i > 0 && sortedArray[i-1].score > sortedArray[i].score) {
                sortedArray.swapAt(i, i-1)
                i -= 1
            }
        }
        
        return sortedArray
    }
}

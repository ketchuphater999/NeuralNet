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
    @IBOutlet weak var genLabel : NSTextField!
    @IBOutlet weak var progressLabel : NSTextField!
    @IBOutlet weak var scoreLabel : NSTextField!
    @IBOutlet weak var progressBar : NSProgressIndicator!
    
    var shouldRun : Bool = false
    var needsRepopulate : Bool = false
    var snakeGame : SnakeGame!
    var networks : [Network] = []
    var outputs : [Double] = []
    var currentGen : Int = 0
    
    let queue = DispatchQueue(label: "com.maya.neural-net")
    
    override init() {
        super.init()
        self.newRun()
    }
    
    @IBAction func newRun(_ sender: Any) {
        queue.async {
            self.newRun()
        }
    }
    
    func newRun() {
        //initialize a fresh randomized set of networks to begin training
        
        networks = []
        //populate the array with randomized networks
        DispatchQueue.main.async {
            self.scoreLabel.isHidden = true
            self.genLabel.isHidden = true
            self.progressLabel.stringValue = "Populating networks..."
            self.progressLabel.isHidden = false
            self.progressBar.minValue = 0
            self.progressBar.maxValue = 999
            self.progressBar.doubleValue = 0
            self.progressBar.isHidden = false
            self.progressBar.display()
        }
        
        for _ in 1...1000 {
            //asynchronously update the progress bar
            DispatchQueue.main.async {
                self.progressBar.increment(by: 1)
                self.progressBar.display()
            }
            
            let net = Network()
            net.configure(layers: 4, nodes: [24,16,16,4])
            net.randomize(weightVariance: 2, biasVariance: 0)
            networks.append(net)
        }
        
        DispatchQueue.main.async {
            self.progressBar.isHidden = true
            self.progressLabel.isHidden = true
        }
        
    }
    
    @IBAction func nextGen(_ sender: Any) {
        //repopulate if needed, then run the next set of networks
        queue.async {
            if self.needsRepopulate {
                self.repopulate(range:100, mutationRate: 0.05)
            }
            self.nextGen()
        }
    }
    
    func nextGen() {
        //run games for each network, then sort the array by score.
        self.currentGen += 1
        
        //update all display values
        DispatchQueue.main.async {
            self.genLabel.stringValue = "Gen: \(self.currentGen)"
            self.genLabel.isHidden = false
            self.progressLabel.isHidden = false
            self.progressLabel.stringValue = "Simulating networks..."
            self.progressBar.minValue = 0
            self.progressBar.maxValue = Double(self.networks.count)
            self.progressBar.isHidden = false
            self.progressBar.doubleValue = 0
            self.progressBar.display()
        }
        var count = 1
        let netQueue = DispatchQueue(label: "networkQueue", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        let netGroup = DispatchGroup()

        //run each game asynchronously and wait for all games to finish before progressing.
        for net in networks {
            netQueue.async {
                netGroup.enter()
                //run each network in the array, saving its final score to the score property of the network.
                
                let game = SnakeGame()
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
                
                netGroup.leave()
                
                //increment the progress bar
                DispatchQueue.main.async {
                    self.progressBar.increment(by: 1)
                    self.progressBar.display()
                }
            }
        }
        netGroup.wait()
        //proceed once all networks have finished playing
        
        //sort networks and flag for repopulation
        networks = sortNets(unsortedArray: networks)!
        networks.reverse()
        print("best score:\(networks[0].score)")
        DispatchQueue.main.async {
            self.progressLabel.isHidden = true
            self.progressBar.isHidden = true
            self.scoreLabel.isHidden = false
            self.scoreLabel.stringValue = "Best Score: \(self.networks[0].score)"
        }
        needsRepopulate = true
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
        //use the the networks within [range] to repopulate the array by crossing and then mutating
        var newNets : [Network] = []
        var bestNets : [Network] = Array(networks[0..<range])
        let total = networks.count
        
        //update display values
        DispatchQueue.main.async {
            self.progressLabel.isHidden = false
            self.progressBar.isHidden = false
            self.progressLabel.stringValue = "Repopulating..."
            self.progressBar.doubleValue = 0
            self.progressBar.minValue = 0
            self.progressBar.maxValue = Double(total)
            self.progressBar.display()
        }
        
        //use the genetic algorithm to create new networks until the array is fully repopulated
        while newNets.count < total {
            DispatchQueue.main.async {
                self.progressBar.doubleValue = Double(newNets.count)
                self.progressBar.display()
            }
            
            //select a pair of networks to 'breed'
            let parent1 = Int(arc4random_uniform(UInt32(range)))
            var parent2 = Int(arc4random_uniform(UInt32(range)))
            while parent1 == parent2 {
                parent2 = Int(arc4random_uniform(UInt32(range)))
            }
            
            //create a new network from the chosen parents, and add it to the array
            let newNet = bestNets[parent1].networkByCrossing(partner: bestNets[parent2])
            newNet.mutate(mutationRate: mutationRate)
            newNets.append(newNet)
        }
        
        networks = newNets
        needsRepopulate = false
        
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
        
        //configure the panel and then trigger it
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.begin(completionHandler: { (result) in
            
            if result == NSApplication.ModalResponse.OK {
                //decode the plist into a model
                let modelURL = panel.url
                let data = try! Data.init(contentsOf: modelURL!)
                let model = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil)
                
                //import the model into the network object
                network.importModel(model: model as! [[Any]])
                
                //initialize a new snake game and let the network play :)
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

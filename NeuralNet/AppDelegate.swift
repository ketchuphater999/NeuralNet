//
//  AppDelegate.swift
//  NeuralNet
//
//  Created by Maya Luna Celeste on 7/6/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        srand48(Int(CFAbsoluteTimeGetCurrent()))
        
        let testNet : Network = Network()
        testNet.configure(layers: 4, nodes: [24,16,16,4])
        testNet.randomize(weightVariance: 2, biasVariance: 0)
        let model = testNet.generateModel()
        let url = URL.init(fileURLWithPath: "/Users/maya/Documents/test.plist")
        print("model saved? \(model.write(to: url, atomically: false))")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    

}


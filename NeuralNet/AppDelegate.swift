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
    
    @IBOutlet weak var snakeView : SnakeView!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        srand48(Int(CFAbsoluteTimeGetCurrent()))
        snakeView.needsDisplay = true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}


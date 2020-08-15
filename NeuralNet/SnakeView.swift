//
//  SnakeView.swift
//  NeuralNet
//
//  Created by Maya Luna Celeste on 8/5/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

import Cocoa

class SnakeView: NSView {
    
    var snakeData : [[SnakeTile]]!
    var headTile : SnakeTile!
    var foodTile : SnakeTile!
    var game : SnakeGame!
    var tileWidth : CGFloat!
    var tileHeight : CGFloat!
    var usesLinks : Bool = true
    
    func isFlipped() -> Bool {
        return true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        //only run this code if the view is attached to a game instance
        if game != nil {
            //calculate the width and height of each game cell using the view size and game size
            tileWidth = frame.size.width / CGFloat(game.width)
            tileHeight = frame.size.height / CGFloat(game.height)
            
            //set the background of the game to gray
            let path = NSBezierPath()
            NSColor.gray.set()
            bounds.fill()
            
            //draw a grid to separate each game cell
            NSColor.black.set()
            for i in 0 ..< game.width {
                path.move(to: NSMakePoint(CGFloat(i)*tileWidth, 0))
                path.line(to: NSMakePoint(CGFloat(i)*tileWidth, frame.size.height))
            }
            for i in 0 ..< game.height {
                path.move(to: NSMakePoint(0, CGFloat(i)*tileHeight))
                path.line(to: NSMakePoint(frame.size.width, CGFloat(i)*tileHeight))
            }
            path.stroke()
            path.removeAllPoints()
            
            //draw the food tile
            NSColor.green.set()
            let food = NSMakeRect(foodTile.position.x*tileWidth,foodTile.position.y*tileHeight,tileWidth,tileHeight)
            food.fill()
            NSColor.black.set()
            food.frame()
            
            //draw the head tile
            var currentTile : SnakeTile! = headTile
            NSColor.red.set()
            let tileRect = NSMakeRect(currentTile.position.x*tileWidth,currentTile.position.y*self.tileHeight,self.tileWidth,self.tileHeight)
            tileRect.fill()
            currentTile = currentTile.next
            
            //iterate through and draw each body tile
            while currentTile != nil {
                NSColor.systemPink.set()
                let tileRect = NSMakeRect(currentTile.position.x*tileWidth,currentTile.position.y*self.tileHeight,self.tileWidth,self.tileHeight)
                tileRect.fill()
                NSColor.black.set()
                tileRect.frame()
                currentTile = currentTile.next
            }
        } else {
            //provide a default game size to display a blank game
            tileWidth = frame.size.width/15
            tileHeight = frame.size.height/15
            
            //set the background of the game to gray
            let path = NSBezierPath()
            NSColor.gray.set()
            bounds.fill()
            
            //draw a grid to separate each game cell
            NSColor.black.set()
            for i in 0 ..< 15 {
                path.move(to: NSMakePoint(CGFloat(i)*tileWidth, 0))
                path.line(to: NSMakePoint(CGFloat(i)*tileWidth, frame.size.height))
            }
            for i in 0 ..< 15 {
                path.move(to: NSMakePoint(0, CGFloat(i)*tileHeight))
                path.line(to: NSMakePoint(frame.size.width, CGFloat(i)*tileHeight))
            }
            path.stroke()
            path.removeAllPoints()
        }
    }
}

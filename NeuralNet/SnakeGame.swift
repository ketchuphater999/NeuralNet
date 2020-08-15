//
//  SnakeGame.swift
//  NeuralNet
//
//  Created by Maya Luna Celeste on 8/5/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

import Cocoa



class SnakeGame: NSObject {
    var score : Int!
    var lifetime : Int!
    var height : Int!
    var width  : Int!
    var remainingMoves : Int!
    var snakeLength : Int!
    var gameActive : Bool!
    var usesLinkgs : Bool!
    var food : SnakeTile!
    var head : SnakeTile!
    var tail : SnakeTile!
    var replay : [[String : SnakeTile]]!
    var snakeView : SnakeView!
    var snakeData : [[SnakeTile]]!
    
    func configure(height newHeight : Int,width newWidth : Int,view newView : SnakeView? = nil) {
        height = newHeight
        width = newWidth
        snakeView = newView
        if snakeView != nil { snakeView.game = self }
        remainingMoves = 200
        snakeLength = 1
        score = 0
        lifetime = 0
        gameActive = true
        snakeData = [[]]
        replay = []
        
        //initialize random starting positions for the head, body, and food
        let headPos = NSMakePoint(CGFloat(Int.random(in: 1..<width-1)), CGFloat(Int.random(in: 1..<height-1)))
        var foodPos = NSMakePoint(CGFloat(Int.random(in: 0..<width)), CGFloat(Int.random(in: 0..<height)))
        var bodyPos = headPos
        let bodyDirection = Int.random(in: 0..<4)
        if bodyDirection == 0 { bodyPos.y -= 1 }
        else if bodyDirection == 1 { bodyPos.y += 1 }
        else if bodyDirection == 2 { bodyPos.x -= 1 }
        else if bodyDirection == 3 { bodyPos.x += 1 }
        while foodPos == headPos || foodPos == bodyPos {
            foodPos = NSMakePoint(CGFloat(Int.random(in: 0..<width)), CGFloat(Int.random(in: 0..<height)))
        }
        
        //initialize the tile objects for the head, tail, and food
        head = SnakeTile()
        tail = SnakeTile()
        food = SnakeTile()
        head.next = tail
        tail.previous = head
        head.position = headPos
        tail.position = bodyPos
        food.position = foodPos
        
        //if a view was passed, provide the view with the head and food, then update it.
        if snakeView != nil {
            snakeView.headTile = head
            snakeView.foodTile = food
            
            //explicitly let the view update on the main queue, in case the game is being run asynchronously
            if snakeView != nil {
                DispatchQueue.main.async {
                    //self.snakeView.setNeedsDisplay(self.snakeView.frame)
                    self.snakeView.needsDisplay = true
                }
            }
        }
        
    }
    
    func run(with input : SnakeAdapter.SnakeMove) -> Bool {
        
        //exit early if the game is not running
        if !gameActive {
            return false
        }
        
        remainingMoves -= 1
        
        //create a new tile with the current position of the head
        let oldHead = SnakeTile()
        oldHead.position = head.position
        
        //move the head by one tile in the direction specified
        if input == SnakeAdapter.SnakeMove.up {
            head.position.y += 1
        } else if input == SnakeAdapter.SnakeMove.down {
            head.position.y -= 1
        } else if input == SnakeAdapter.SnakeMove.left {
            head.position.x -= 1
        } else if input == SnakeAdapter.SnakeMove.right {
            head.position.x += 1
        }
        
        //end the game if the head has exited the bounds of the game, if the head has intersected with another part of the snake's body, or if the snake has run out of moves
        if head.position.x < 0 || head.position.x >= CGFloat(width) || head.position.y < 0 || head.position.y > CGFloat(height) || self.doesHit(point: head.position, head: true) || remainingMoves < 0 {
            gameActive = false
            if snakeView != nil {
                DispatchQueue.main.async {
                    //self.snakeView.setNeedsDisplay(self.snakeView.frame)
                    self.snakeView.needsDisplay = true
                }
            }
            return false
        }
        
        //set oldHead to type body and insert it into the list where the head previously was
        oldHead.tileType = SnakeTile.TileType.body
        oldHead.next = head.next
        oldHead.previous = head
        head.next.previous = oldHead
        head.next = oldHead
        
        //if the snake has eaten a food piece, increase score and remaining moves. otherwise, remove the last tail piece.
        if doesHit(point: food.position,head: false) {
            remainingMoves += 100
            if remainingMoves > 500 { remainingMoves = 500 }
            score += 1
            snakeLength += 1
            newFood()
        } else {
            tail = tail.previous
            tail.next = nil
        }
        
        lifetime += 1
        
        //explicitly let the view update on the main queue, in case the game is being run asynchronously
        if snakeView != nil {
            DispatchQueue.main.async {
                self.snakeView.needsDisplay = true
            }
        }
        
        //add the current state of the game to its replay
        var state : [String : SnakeTile] = [:]
        state["head"] = head.copy() as? SnakeTile
        state["food"] = food.copy() as? SnakeTile
        replay.append(state)
        
        return true
    }
    
    func newFood() {
        //generate a new food position that doesn't intersect with the snake head or body
        var foodPos = NSMakePoint(CGFloat(Int.random(in: 0..<width)),CGFloat(Int.random(in: 0..<height)))
        while doesHit(point: foodPos, head: false) {
            foodPos = NSMakePoint(CGFloat(Int.random(in: 0..<width)),CGFloat(Int.random(in: 0..<height)))
        }
        food.position = foodPos
    }
    
    func inputs() -> [Double] {
        
        var vision : [Double] = []
        var body : [NSPoint] = []
        let headPos = head.position
        let foodPos = food.position
        
        //fill the body array with each point value on the snake's body, for easier calculations
        var tile : SnakeTile! = head.next
        while tile != nil {
            body.append(tile.position)
            tile = tile.next
        }
        
        //check distance to wall
        vision.append(Double(1 / (CGFloat(self.height) - headPos.y)))                                                               //n
        vision.append(Double(1 / (CGFloat(self.width) - headPos.x)))                                                                //e
        vision.append(Double(1 / (headPos.y + 1)))                                                                                  //s
        vision.append(Double(1 / (headPos.x + 1)))                                                                                  //w
        vision.append(max(vision[0],vision[1]))                                                                                     //ne
        vision.append(max(vision[1],vision[2]))                                                                                     //se
        vision.append(max(vision[2],vision[3]))                                                                                     //sw
        vision.append(max(vision[3],vision[0]))                                                                                     //nw
        
        //check if food is on a diagonal, then populate array
        var yDist = Double(foodPos.y - headPos.y)
        var xDist = Double(foodPos.x - headPos.x)
        var isDiagonal = abs(Int32(yDist)) ==  abs(Int32(xDist))
        var xEqual = foodPos.x == headPos.x
        var yEqual = foodPos.y == headPos.y
        
        if !isDiagonal {
            vision.append(boolAsDouble(xEqual && foodPos.y > headPos.y) / fabs(yDist))                                              //n
            vision.append(boolAsDouble(yEqual && foodPos.x > headPos.x) / fabs(xDist))                                              //e
            vision.append(boolAsDouble(xEqual && foodPos.y < headPos.y) / fabs(yDist))                                              //s
            vision.append(boolAsDouble(yEqual && foodPos.x < headPos.x) / fabs(xDist))                                              //w
            vision.append(contentsOf: [0,0,0,0])
        } else {
            vision.append(contentsOf: [0,0,0,0])
            vision.append(boolAsDouble(yDist > 0 && xDist > 0) / fabs(xDist))                                                       //ne
            vision.append(boolAsDouble(yDist < 0 && xDist > 0) / fabs(xDist))                                                       //se
            vision.append(boolAsDouble(yDist < 0 && xDist < 0) / fabs(xDist))                                                       //sw
            vision.append(boolAsDouble(yDist > 0 && xDist < 0) / fabs(xDist))                                                       //nw
        }
        
        //check diagonals and distance to each body segment, populating array with the distance to the closest segment
        vision.append(contentsOf: [0,0,0,0,0,0,0,0])
        for tilePos in body {
            yDist = Double(tilePos.y - headPos.y)
            xDist = Double(tilePos.x - headPos.x)
            isDiagonal = abs(Int32(xDist)) == abs(Int32(yDist))
            xEqual = tilePos.x == headPos.x
            yEqual = tilePos.y == headPos.y
            
            if !isDiagonal {
                vision[16] = max(boolAsDouble(xEqual && tilePos.y > headPos.y), vision[16])                                         //n
                vision[17] = max(boolAsDouble(yEqual && tilePos.x > headPos.x), vision[17])                                         //e
                vision[18] = max(boolAsDouble(xEqual && tilePos.y < headPos.y), vision[18])                                         //s
                vision[19] = max(boolAsDouble(yEqual && tilePos.x < headPos.x), vision[19])                                         //w
            } else {
                vision[20] = max(boolAsDouble(yDist > 0 && xDist > 0), vision[20])                                                  //ne
                vision[21] = max(boolAsDouble(yDist < 0 && xDist > 0), vision[21])                                                  //se
                vision[22] = max(boolAsDouble(yDist < 0 && xDist < 0), vision[22])                                                  //sw
                vision[23] = max(boolAsDouble(yDist > 0 && xDist < 0), vision[23])                                                  //nw
            }
        }
        
        //replace NaN with 0 in all instances
        for i in 0 ..< vision.count {
            if vision[i].isNaN {
                vision[i] = 0
            }
        }
        
        return vision
    }
    
    func doesHit(point : NSPoint,head isHead : Bool) -> Bool {
        var doesHit = false
        var tile : SnakeTile! = head
        
        if isHead {
            //skip the head and check each tile in the list for hits
            tile = head.next
            while tile != nil {
                if point.x == tile.position.x && point.y == tile.position.y && (tile.next != nil || tile.previous == head) {
                    doesHit = true
                    break
                }
                tile = tile.next
            }
            
        } else {
            //check each tile in the list for hits
            while tile != nil {
                if point.x == tile.position.x && point.y == tile.position.y && (tile.next != nil || tile.previous == head) {
                    doesHit = true
                    break
                }
                tile = tile.next
            }
        }
        
        return doesHit
    }

    func fitness() -> Double {
        //calculate fitness
        var fitness : Double = 0
        if score < 10 {
            fitness = round(Double(lifetime*lifetime)) * pow(2, Double(score))
        } else {
            fitness = round(Double(lifetime*lifetime))
            fitness *= pow(2,10)
            fitness *= Double(score - 9)
        }
        return fitness
    }
    
    func runReplay(_ replay : [[String : SnakeTile]]) {
        gameActive = true
        for state in replay {
            //load each state from the replay and display them
            food = state["food"]
            head = state["head"]
            snakeView.foodTile = food
            snakeView.headTile = head
            DispatchQueue.main.async {
                self.snakeView.needsDisplay = true
            }
            usleep(20000)
        }
    }
    
    @inline(__always) func boolAsDouble(_ val : Bool) -> Double {
        return Double(truncating: NSNumber(booleanLiteral: val))
    }
    
}

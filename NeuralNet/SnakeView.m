
//
//  SnakeView.m
//  SnakeNet
//
//  Created by Maya Luna Celeste on 5/7/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

#import "SnakeView.h"
#import "SnakeGame.h"
#import "SnakeTile.h"
@implementation SnakeView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
//    int xSegment = (int)roundf(self.frame.size.width/self.game.width);
//    int ySegment = (int)roundf(self.frame.size.width/self.game.height);
    
    float xSegment = self.frame.size.width/self.game.width;
    float ySegment = self.frame.size.height/self.game.height;
    
    self.tileWidth = xSegment;
    self.tileHeight = ySegment;
    
    
    if (self.usesLinks) {
            NSBezierPath *bezierPath = [NSBezierPath new];
            [[NSColor grayColor] set];
            NSRect bounds = NSMakeRect(0,0,self.frame.size.width,self.frame.size.height);
            NSRectFill(bounds);
            
            [[NSColor blackColor] set];
            for (int i = 1; i < self.game.width; i++) {
                [bezierPath moveToPoint:NSMakePoint(i*self.tileWidth, 0)];
                [bezierPath lineToPoint:NSMakePoint(i*self.tileWidth, self.frame.size.height)];
                [bezierPath stroke];
            }
            for (int i = 1; i < self.game.height; i++) {
                [bezierPath moveToPoint:NSMakePoint(0, i*self.tileHeight)];
                [bezierPath lineToPoint:NSMakePoint(self.frame.size.width, i*self.tileHeight)];
                [bezierPath stroke];
            }

            
            
            
            NSRect food = NSMakeRect(self.food.position.x*self.tileWidth,self.food.position.y*self.tileHeight,self.tileWidth,self.tileHeight);
            [[NSColor greenColor] set];
            NSRectFill(food);
            [[NSColor blackColor] set];
            NSFrameRect(food);
            
            SnakeTile *currentTile = self.snakeHead;
            
            NSRect tileRect = NSMakeRect(currentTile.position.x*self.tileWidth,currentTile.position.y*self.tileHeight,self.tileWidth,self.tileHeight);
            [[NSColor redColor] set];
            NSRectFill(tileRect);
            
            [[NSColor blackColor] set];
            NSFrameRect(tileRect);
            
            NSRect eye1 = NSMakeRect(currentTile.position.x*self.tileWidth+(self.tileWidth/3)-1,currentTile.position.y*self.tileHeight+(self.tileHeight/3)-1,3,3);
            NSRect eye2 = NSMakeRect(currentTile.position.x*self.tileWidth+(2*self.tileWidth/3)-1,currentTile.position.y*self.tileHeight+(self.tileHeight/3)-1,3,3);
            NSRectFill(eye1);
            NSRectFill(eye2);
        
            [bezierPath moveToPoint:NSMakePoint(currentTile.position.x*self.tileWidth+(self.tileWidth/3), currentTile.position.y*self.tileHeight+(2*self.tileHeight/3))];
            [bezierPath curveToPoint:NSMakePoint(currentTile.position.x*self.tileWidth+(2*self.tileWidth/3)+2, currentTile.position.y*self.tileHeight+(2*self.tileHeight/3))controlPoint1:NSMakePoint(currentTile.position.x*self.tileWidth+(self.tileWidth/3)-2, currentTile.position.y*self.tileHeight+(2*self.tileHeight/3)+2)   controlPoint2:NSMakePoint(currentTile.position.x*self.tileWidth+(2*self.tileWidth/3)+4, currentTile.position.y*self.tileHeight+(2*self.tileHeight/3)+2)];
            [bezierPath setLineWidth:2];
            [bezierPath stroke];
            [bezierPath removeAllPoints];

            currentTile = currentTile.next;
            
            while (currentTile) {
                NSRect tileRect = NSMakeRect(currentTile.position.x*self.tileWidth,currentTile.position.y*self.tileHeight,self.tileWidth,self.tileHeight);
                [[NSColor systemPinkColor] set];
                NSRectFill(tileRect);
                [[NSColor blackColor] set];
                NSFrameRect(tileRect);
                currentTile = currentTile.next;
            }
        
    }
    
    else {
        NSBezierPath *bezierPath = [NSBezierPath bezierPath];
        
        
        for(int i = 0; i < self.game.width; i++){
            NSArray<SnakeTile *> *column = [self.snakeData objectAtIndex:i];
            for(int j = 0; j < self.game.height; j++){
        
        
                int tileType = [column objectAtIndex:j].tileType;
        
                if (tileType == 0) {
                    [[NSColor grayColor] set];
                } else if (tileType == 1) {
                    [[NSColor systemPinkColor] set];
                } else if (tileType == 2) {
                    [[NSColor redColor] set];
                } else if (tileType == 3) {
                    [[NSColor greenColor] set];
                }
        
        
                [bezierPath moveToPoint:NSMakePoint(i*self.tileWidth,j*self.tileHeight)];
                [bezierPath relativeLineToPoint:NSMakePoint(self.tileWidth,0)];
                [bezierPath relativeLineToPoint:NSMakePoint(0, self.tileHeight)];
                [bezierPath relativeLineToPoint:NSMakePoint(self.tileWidth*-1,0)];
                [bezierPath relativeLineToPoint:NSMakePoint(0, self.tileHeight*-1)];
        
        
                [bezierPath fill];
                [bezierPath removeAllPoints];
        
        
                if (tileType == 1){
                    [[NSColor blackColor] set];
        
                    [bezierPath moveToPoint:NSMakePoint(i*self.tileWidth+(self.tileWidth/3),j*self.tileHeight+(self.tileHeight/3))];
                    [bezierPath relativeLineToPoint:NSMakePoint(2, 0)];
                    [bezierPath relativeLineToPoint:NSMakePoint(0, 2)];
                    [bezierPath relativeLineToPoint:NSMakePoint(-2, 0)];
                    [bezierPath relativeLineToPoint:NSMakePoint(0, -2)];
                    [bezierPath fill];
                    [bezierPath removeAllPoints];
                    [bezierPath moveToPoint:NSMakePoint(i*self.tileWidth+(2*self.tileWidth/3),j*self.tileHeight+(self.tileHeight/3))];
                    [bezierPath relativeLineToPoint:NSMakePoint(2, 0)];
                    [bezierPath relativeLineToPoint:NSMakePoint(0, 2)];
                    [bezierPath relativeLineToPoint:NSMakePoint(-2, 0)];
                    [bezierPath relativeLineToPoint:NSMakePoint(0, -2)];
                    [bezierPath fill];
        
                    [bezierPath removeAllPoints];
        
        
                    [bezierPath moveToPoint:NSMakePoint(i*self.tileWidth+(self.tileWidth/3), j*self.tileHeight+(2*self.tileHeight/3))];
                    [bezierPath curveToPoint:NSMakePoint(i*self.tileWidth+(2*self.tileWidth/3)+2, j*self.tileHeight+(2*self.tileHeight/3))  controlPoint1:NSMakePoint(i*self.tileWidth+(self.tileWidth/3)-2, j*self.tileHeight+(2*self.tileHeight/3)+2)     controlPoint2:NSMakePoint(i*self.tileWidth+(2*self.tileWidth/3)+4, j*self.tileHeight+(2*self.tileHeight/3)+2)];
                    [bezierPath setLineWidth:2];
                    [bezierPath stroke];
                    [bezierPath removeAllPoints];
                }
    
            }
        
        
        }
        
        if (!self.game.gameActive) {
            [bezierPath moveToPoint:NSMakePoint(0, 0)];
            [bezierPath relativeLineToPoint:NSMakePoint(0, self.frame.size.width)];
            [bezierPath relativeLineToPoint:NSMakePoint(self.frame.size.height, 0)];
            [bezierPath relativeLineToPoint:NSMakePoint(0, -1*self.frame.size.width)];
            [bezierPath relativeLineToPoint:NSMakePoint(-1*self.frame.size.height, 0)];
            [[NSColor redColor] set];
            [bezierPath fill];
            [bezierPath removeAllPoints];
        }
        
    }
    // Drawing code here.
}

- (bool)isFlipped{
    return YES;
}

@end

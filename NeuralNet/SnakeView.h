//
//  SnakeView.h
//  SnakeNet
//
//  Created by Maya Luna Celeste on 5/7/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class SnakeTile;
@class SnakeGame;

@interface SnakeView : NSView

@property (weak) NSArray<NSArray<SnakeTile *> *> *snakeData;
@property (strong) SnakeTile                       *snakeHead;
@property (strong) SnakeTile                       *food;
@property (weak) SnakeGame                         *game;
@property (assign) float                            tileWidth;
@property (assign) float                            tileHeight;
@property (assign) bool                             usesLinks;

- (bool)isFlipped;
@end

NS_ASSUME_NONNULL_END

//
//  SnakeGame.h
//  SnakeNet
//
//  Created by Maya Luna Celeste on 5/7/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnakeAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@class SnakeTile;
@class SnakeView;


@interface SnakeGame : NSObject

@property (strong) IBOutlet SnakeView *snakeView;
@property (strong)          NSMutableArray<NSMutableArray<SnakeTile *> *> *snakeData;

@property (assign)          int score;
@property (assign)          int lifetime;
@property (assign)          int height;
@property (assign)          int width;
@property (assign)          int remainingMoves;
@property (assign)          int snakeLength;
@property (assign)          bool gameActive;
@property (assign)          bool usesLinks;
@property (strong)          SnakeTile *food;
@property (strong)          SnakeTile *head;
@property (strong)          SnakeTile *tail;
@property (strong)          NSMutableArray *replay;

- (bool)runGameWithInput:(SnakeInputType)input;
- (void)createFood;
- (void)configureWithHeight:(int)height width:(int)width useLinks:(bool)link;
- (void)configureWithHeight:(int)height width:(int)width useLinks:(bool)link view:(SnakeView *)view;
- (double)calculateFitness;
- (bool)doesPointHitSnake:(NSPoint)point isHead:(bool)head;
- (void)runGameFromReplay:(NSArray *)replay;

- (NSArray<NSNumber *> *)inputs;

@end

NS_ASSUME_NONNULL_END

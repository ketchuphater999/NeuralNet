//
//  SnakeTile.h
//  SnakeNet
//
//  Created by Maya Luna Celeste on 5/7/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TileType){
    TileTypeEmpty,
    TileTypeHead,
    TileTypeBody,
    TileTypeFood
};

@interface SnakeTile : NSObject <NSCopying>

@property (assign) NSInteger tileType;
@property (assign) int age;
@property (assign) NSPoint position;
@property (strong, nullable) SnakeTile *next;
@property (strong, nullable) SnakeTile *previous;

@end

NS_ASSUME_NONNULL_END

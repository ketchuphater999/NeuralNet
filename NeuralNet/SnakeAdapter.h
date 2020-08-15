//
//  SnakeAdapter.h
//  SnakeNet
//
//  Created by Maya Luna Celeste on 4/30/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SnakeInputType){
    SnakeInputTypeUp,
    SnakeInputTypeDown,
    SnakeInputTypeLeft,
    SnakeInputTypeRight,
    SnakeInputTypeError
};

NS_ASSUME_NONNULL_BEGIN

@interface SnakeAdapter : NSObject

@property (strong) NSArray<NSNumber *>    *outputs;

- (SnakeInputType)snakeInput;

@end

NS_ASSUME_NONNULL_END

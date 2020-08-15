//
//  SnakeAdapter.m
//  SnakeNet
//
//  Created by Maya Luna Celeste on 4/30/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

#import "SnakeAdapter.h"

@implementation SnakeAdapter

- (SnakeInputType)snakeInput{
    int value = 0;
    for(int i = 0; i < [self.outputs count]; i++){
        if([[self.outputs objectAtIndex:i] doubleValue] > [[self.outputs objectAtIndex:value] doubleValue]) {
            value = i;
        }
    }
    
    SnakeInputType input = SnakeInputTypeError;
    
    if (value == 0){
        input = SnakeInputTypeUp;
    } else if (value == 1){
        input = SnakeInputTypeDown;
    } else if (value == 2){
        input = SnakeInputTypeLeft;
    } else if (value == 3){
        input = SnakeInputTypeRight;
    }
    return input;
}

@end

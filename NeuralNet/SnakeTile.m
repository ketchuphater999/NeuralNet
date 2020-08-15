//
//  SnakeTile.m
//  SnakeNet
//
//  Created by Maya Luna Celeste on 5/7/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

#import "SnakeTile.h"

@implementation SnakeTile

-(instancetype)init{
    self.age = 0;
    self.tileType = TileTypeEmpty;
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    SnakeTile *copy = [SnakeTile new];
    copy.age = self.age;
    copy.tileType = self.tileType;
    copy.position = self.position;
    copy.next = [self.next copyWithZone:nil];
    copy.next.previous = self;
    return copy;
}

@end

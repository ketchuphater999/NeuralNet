//
//  SnakeGame.m
//  SnakeNet
//
//  Created by Maya Luna Celeste on 5/7/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

#import "SnakeGame.h"
#import "SnakeTile.h"
#import "SnakeView.h"

@implementation SnakeGame


- (void)configureWithHeight:(int)height width:(int)width useLinks:(bool)link{
    self.height = height;
    self.width = width;
    self.remainingMoves = 200;
    self.snakeLength = 1;
    self.score = 0;
    self.lifetime = 0;
    self.snakeData = [NSMutableArray new];
    self.gameActive = true;
    self.usesLinks = link;
    self.replay = [NSMutableArray new];
    
    if (link){
        
        int headX = arc4random_uniform(width);
        int headY = arc4random_uniform(height);
        int foodX = arc4random_uniform(width);
        int foodY = arc4random_uniform(height);
        int bodyX = 0;
        int bodyY = 0;
        
        int bodyDirection = arc4random_uniform(4);
        if (bodyDirection == 0){
            bodyX = headX;
            bodyY = headY - 1;
        } else if (bodyDirection == 1) {
            bodyX = headX;
            bodyY = headY + 1;
        } else if (bodyDirection == 2) {
            bodyX = headX - 1;
            bodyY = headY;
        } else if (bodyDirection == 3) {
            bodyX = headX + 1;
            bodyY = headY;
        }
        
        while ((bodyX < 0) || (bodyX >= width) || (bodyY < 0) || (bodyY >= height)){
            bodyDirection = arc4random_uniform(4);
            if (bodyDirection == 0){
                bodyX = headX;
                bodyY = headY - 1;
            } else if (bodyDirection == 1) {
                bodyX = headX;
                bodyY = headY + 1;
            } else if (bodyDirection == 2) {
                bodyX = headX - 1;
                bodyY = headY;
            } else if (bodyDirection == 3) {
                bodyX = headX + 1;
                bodyY = headY;
            }
        }
        
        while(((foodX == headX) && (foodY == headY)) || ((foodX == bodyX) && (foodY == bodyY))) {
            foodX = arc4random_uniform(width);
            foodY = arc4random_uniform(height);
        }
        
        self.head = [SnakeTile new];
        self.tail = [SnakeTile new];
        self.food = [SnakeTile new];
        
        self.head.next = self.tail;
        self.tail.previous = self.head;
        
        self.head.position = NSMakePoint(headX,headY);
        self.tail.position = NSMakePoint(bodyX,bodyY);
        self.food.position = NSMakePoint(foodX,foodY);
        
    }
    
    else {
        
    int headX = arc4random_uniform(width);
    int headY = arc4random_uniform(height);
    int foodX = arc4random_uniform(width);
    int foodY = arc4random_uniform(height);
    int bodyX = 0;
    int bodyY = 0;
    
    int bodyDirection = arc4random_uniform(4);
    if (bodyDirection == 0){
        bodyX = headX;
        bodyY = headY - 1;
    } else if (bodyDirection == 1) {
        bodyX = headX;
        bodyY = headY + 1;
    } else if (bodyDirection == 2) {
        bodyX = headX - 1;
        bodyY = headY;
    } else if (bodyDirection == 3) {
        bodyX = headX + 1;
        bodyY = headY;
    }
    
    while ((bodyX < 0) || (bodyX >= width) || (bodyY < 0) || (bodyY >= height)){
        bodyDirection = arc4random_uniform(4);
        if (bodyDirection == 0){
            bodyX = headX;
            bodyY = headY - 1;
        } else if (bodyDirection == 1) {
            bodyX = headX;
            bodyY = headY + 1;
        } else if (bodyDirection == 2) {
            bodyX = headX - 1;
            bodyY = headY;
        } else if (bodyDirection == 3) {
            bodyX = headX + 1;
            bodyY = headY;
        }
    }
    
    while(((foodX == headX) && (foodY == headY)) || ((foodX == bodyX) && (foodY == bodyY))) {
        foodX = arc4random_uniform(width);
        foodY = arc4random_uniform(height);
    }
        
    for (int i = 0; i < width; i++){
        NSMutableArray *row = [NSMutableArray new];
        for (int j = 0; j < height; j++){
            SnakeTile *tile = [SnakeTile new];
            [row addObject:tile];
        }
        [self.snakeData addObject:row];
    }
    
    [self.snakeData[headX][headY] setTileType:TileTypeHead];
    [self.snakeData[bodyX][bodyY] setTileType:TileTypeBody];
    self.snakeData[bodyX][bodyY].age = 1;
    [self.snakeData[foodX][foodY] setTileType:TileTypeFood];
} // initializes game using full array enumeration
    
    
}

- (void)configureWithHeight:(int)height width:(int)width useLinks:(bool)link view:(SnakeView *)view{
    self.height = height;
    self.width = width;
    self.remainingMoves = 200;
    self.snakeLength = 1;
    self.score = 0;
    self.lifetime = 0;
    self.snakeData = [NSMutableArray new];
    self.gameActive = true;
    self.snakeView = view;
    self.snakeView.game = self;
    self.usesLinks = link;
    self.replay = [NSMutableArray new];
    

    if (link){

        [self.snakeView setUsesLinks:true];
        
        int headX = arc4random_uniform(width);
        int headY = arc4random_uniform(height);
        int foodX = arc4random_uniform(width);
        int foodY = arc4random_uniform(height);
        int bodyX = 0;
        int bodyY = 0;
        
        int bodyDirection = arc4random_uniform(4);
        if (bodyDirection == 0){
            bodyX = headX;
            bodyY = headY - 1;
        } else if (bodyDirection == 1) {
            bodyX = headX;
            bodyY = headY + 1;
        } else if (bodyDirection == 2) {
            bodyX = headX - 1;
            bodyY = headY;
        } else if (bodyDirection == 3) {
            bodyX = headX + 1;
            bodyY = headY;
        }
        
        while ((bodyX < 0) || (bodyX >= width) || (bodyY < 0) || (bodyY >= height)){
            bodyDirection = arc4random_uniform(4);
            if (bodyDirection == 0){
                bodyX = headX;
                bodyY = headY - 1;
            } else if (bodyDirection == 1) {
                bodyX = headX;
                bodyY = headY + 1;
            } else if (bodyDirection == 2) {
                bodyX = headX - 1;
                bodyY = headY;
            } else if (bodyDirection == 3) {
                bodyX = headX + 1;
                bodyY = headY;
            }
        }
        
        while(((foodX == headX) && (foodY == headY)) || ((foodX == bodyX) && (foodY == bodyY))) {
            foodX = arc4random_uniform(width);
            foodY = arc4random_uniform(height);
        }
        
        self.head = [SnakeTile new];
        self.tail = [SnakeTile new];
        self.food = [SnakeTile new];
        
        self.head.next = self.tail;
        self.tail.previous = self.head;
        
        self.head.position = NSMakePoint(headX,headY);
        self.tail.position = NSMakePoint(bodyX,bodyY);
        self.food.position = NSMakePoint(foodX,foodY);

        [self.snakeView setSnakeHead:self.head];
        [self.snakeView setFood:self.food];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.snakeView setNeedsDisplay:true];
        });
    }
    
    else {
        
        [self.snakeView setUsesLinks:false];
    
        int headX = arc4random_uniform(width);
        int headY = arc4random_uniform(height);
        int foodX = arc4random_uniform(width);
        int foodY = arc4random_uniform(height);
        int bodyX = 0;
        int bodyY = 0;
        
        int bodyDirection = arc4random_uniform(4);
        if (bodyDirection == 0){
            bodyX = headX;
            bodyY = headY - 1;
        } else if (bodyDirection == 1) {
            bodyX = headX;
            bodyY = headY + 1;
        } else if (bodyDirection == 2) {
            bodyX = headX - 1;
            bodyY = headY;
        } else if (bodyDirection == 3) {
            bodyX = headX + 1;
            bodyY = headY;
        }
        
        while ((bodyX < 0) || (bodyX >= width) || (bodyY < 0) || (bodyY >= height)){
            bodyDirection = arc4random_uniform(4);
            if (bodyDirection == 0){
                bodyX = headX;
                bodyY = headY - 1;
            } else if (bodyDirection == 1) {
                bodyX = headX;
                bodyY = headY + 1;
            } else if (bodyDirection == 2) {
                bodyX = headX - 1;
                bodyY = headY;
            } else if (bodyDirection == 3) {
                bodyX = headX + 1;
                bodyY = headY;
            }
        }
        
        while(((foodX == headX) && (foodY == headY)) || ((foodX == bodyX) && (foodY == bodyY))) {
            foodX = arc4random_uniform(width);
            foodY = arc4random_uniform(height);
        }
        
        for (int i = 0; i < width; i++){
            NSMutableArray *row = [NSMutableArray new];
            for (int j = 0; j < height; j++){
                SnakeTile *tile = [SnakeTile new];
                [row addObject:tile];
            }
            [self.snakeData addObject:row];
        }
        
        [self.snakeData[headX][headY] setTileType:TileTypeHead];
        [self.snakeData[bodyX][bodyY] setTileType:TileTypeBody];
        self.snakeData[bodyX][bodyY].age = 1;
        [self.snakeData[foodX][foodY] setTileType:TileTypeFood];
        
        self.snakeView.snakeData = self.snakeData;
        [self.snakeView setNeedsDisplay:true];
    } // initializes game using full array enumeration
    
}

- (bool)runGameWithInput:(SnakeInputType)input{
    
    if (!self.gameActive) {
        return false;
    }
    
    if (self.usesLinks){
        self.remainingMoves--;
        SnakeTile *oldHead = [SnakeTile new];
        oldHead.position = self.head.position;
        
        if (input == SnakeInputTypeUp) {
            self.head.position = NSMakePoint(self.head.position.x,self.head.position.y-1);
        } else if (input == SnakeInputTypeDown) {
            self.head.position = NSMakePoint(self.head.position.x,self.head.position.y+1);
        } else if (input == SnakeInputTypeLeft) {
            self.head.position = NSMakePoint(self.head.position.x-1,self.head.position.y);
        } else if (input == SnakeInputTypeRight) {
            self.head.position = NSMakePoint(self.head.position.x+1,self.head.position.y);
        }
        
        if((self.head.position.x < 0) || (self.head.position.x >= self.width) || (self.head.position.y < 0) || (self.head.position.y >= self.height) || ([self doesPointHitSnake:self.head.position isHead:true]) || (self.remainingMoves < 0)) {
            self.gameActive = false;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.snakeView setNeedsDisplay:true];
            });
            return false;
        }
        
        [oldHead setTileType:TileTypeBody];
        [oldHead setNext:self.head.next];
        [oldHead setPrevious:self.head];
        [self.head.next setPrevious:oldHead];
        [self.head setNext:oldHead];
        
        if ([self doesPointHitSnake:self.food.position isHead:false]) {
            self.remainingMoves = self.remainingMoves + 100;
            if (self.remainingMoves > 500) {self.remainingMoves = 500;}
            self.score++;
            self.snakeLength++;
            [self createFood];
        } else {
            self.tail.previous.next = nil;
            self.tail = self.tail.previous;
        }
                
        self.lifetime++;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.snakeView setNeedsDisplay:true];
        });
    }
    
    else {
        
        self.remainingMoves--;
        
        for(int i = 0; i < self.width; i++){
            NSArray<SnakeTile *> *column = [self.snakeData objectAtIndex:i];
            for(int j = 0; j < self.height; j++){
                SnakeTile *tile = [column objectAtIndex:j];
                
                
                if(tile.tileType == TileTypeHead) {
                    
                    if (input == SnakeInputTypeUp) {
                        if (j-1 < 0) {
                            self.gameActive = false;
                            [self.snakeView setNeedsDisplay:true];
                            return false;
                        }
                        
                        if (self.snakeData[i][j-1].tileType == TileTypeBody) {
                            self.gameActive = false;
                            [self.snakeView setNeedsDisplay:true];
                            return false;
                        }
                        
                        if (self.snakeData[i][j-1].tileType == TileTypeFood) {
                            self.score++;
                            self.snakeLength++;
                            self.remainingMoves = self.remainingMoves + 100;
                            if (self.remainingMoves > 500) {
                                self.remainingMoves = 500;
                            }
                            [self createFood];
                        }
                        
                        [self.snakeData[i][j-1] setTileType:TileTypeHead];
                        [tile setTileType:TileTypeBody];
                    } else if (input == SnakeInputTypeDown) {
                        if (j+1 >= self.height) {
                            self.gameActive = false;
                            [self.snakeView setNeedsDisplay:true];
                            return false;
                        }
                        
                        if (self.snakeData[i][j+1].tileType == TileTypeBody) {
                            self.gameActive = false;
                            [self.snakeView setNeedsDisplay:true];
                            return false;
                        }
                        
                        if (self.snakeData[i][j+1].tileType == TileTypeFood) {
                            self.score++;
                            self.snakeLength++;
                            self.remainingMoves = self.remainingMoves + 100;
                            if (self.remainingMoves > 500) {
                                self.remainingMoves = 500;
                            }
                            [self createFood];
                        }
                        
                        [self.snakeData[i][j+1] setTileType:TileTypeHead];
                        [tile setTileType:TileTypeBody];
                    } else if (input == SnakeInputTypeLeft) {
                        if (i-1 < 0) {
                            self.gameActive = false;
                            [self.snakeView setNeedsDisplay:true];
                            return false;
                        }
                        if (self.snakeData[i-1][j].tileType == TileTypeBody) {
                            self.gameActive = false;
                            [self.snakeView setNeedsDisplay:true];
                            return false;
                        }
                        
                        if (self.snakeData[i-1][j].tileType == TileTypeFood) {
                            self.score++;
                            self.snakeLength++;
                            self.remainingMoves = self.remainingMoves + 100;
                            if (self.remainingMoves > 500) {
                                self.remainingMoves = 500;
                            }
                            [self createFood];
                        }
                        
                        [self.snakeData[i-1][j] setTileType:TileTypeHead];
                        [tile setTileType:TileTypeBody];
                    } else if (input == SnakeInputTypeRight) {
                        if (i+1 >= self.width) {
                            self.gameActive = false;
                            [self.snakeView setNeedsDisplay:true];
                            return false;
                        }
                        
                        if (self.snakeData[i+1][j].tileType == TileTypeBody) {
                            self.gameActive = false;
                            [self.snakeView setNeedsDisplay:true];
                            return false;
                        }
                        
                        
                        if (self.snakeData[i+1][j].tileType == TileTypeFood) {
                            self.score++;
                            self.snakeLength++;
                            self.remainingMoves = self.remainingMoves + 100;
                            if (self.remainingMoves > 500) {
                                self.remainingMoves = 500;
                            }
                            [self createFood];
                        }
                        
                        [self.snakeData[i+1][j] setTileType:TileTypeHead];
                        [tile setTileType:TileTypeBody];
                    }
                    tile.age = 0;
                    goto foundHead;
                }
                        
            }
            
        }
        foundHead:
        
        if (self.remainingMoves <= 0) {
            self.gameActive = false;
            [self.snakeView setNeedsDisplay:true];
            return false;
        }
        
        for(int i = 0; i < self.width; i++){
            NSArray<SnakeTile *> *column = [self.snakeData objectAtIndex:i];
            for(int j = 0; j < self.height; j++){
                SnakeTile *tile = [column objectAtIndex:j];
                
                
                if(tile.tileType == TileTypeBody) {
                    if (tile.age == self.snakeLength){
                        [tile setTileType:TileTypeEmpty];
                    }
                    tile.age++;
                }
                        
            }
            
        }
        
        self.lifetime++;
        
        if(self.snakeView){
            self.snakeView.snakeData = self.snakeData;
            [self.snakeView setNeedsDisplay:true];
        }
        
    }
    
    NSMutableDictionary *state = [NSMutableDictionary new];
    [state setObject:[self.head copyWithZone:nil] forKey:@"head"];
    [state setObject:[self.food copyWithZone:nil] forKey:@"food"];
    [self.replay addObject:state];
    return true;

}

- (double)calculateFitness{
    double fitness;
    if (self.score < 10){
        fitness = roundf(self.lifetime*self.lifetime) * powf(2,self.score);
    } else {
        fitness = roundf(self.lifetime*self.lifetime);
        fitness *= powf(2,10);
        fitness *= (self.score - 9);
    }
    if (fitness == 40000){
        
    }
    return fitness;
}

- (void)createFood{
    
    if (self.usesLinks){
        NSPoint food = NSMakePoint(arc4random_uniform(self.width),arc4random_uniform(self.height));
        while([self doesPointHitSnake:food isHead:false]){
            food = NSMakePoint(arc4random_uniform(self.width),arc4random_uniform(self.height));
        }
        self.food.position = food;
    } else {
        
        int foodX = arc4random_uniform(self.width);
        int foodY = arc4random_uniform(self.height);
        
        while((self.snakeData[foodX][foodY].tileType == TileTypeBody) || (self.snakeData[foodX][foodY].tileType == TileTypeHead)){
            foodX = arc4random_uniform(self.width);
            foodY = arc4random_uniform(self.height);
        }
        
        self.snakeData[foodX][foodY].tileType = TileTypeFood;
    }
}

- (bool)doesPointHitSnake:(NSPoint)point isHead:(bool)head {
    bool doesHit = false;
    SnakeTile *tile;
    if (head){
        tile = self.head.next;
        while (tile) {
            if ((point.x == tile.position.x) && (point.y == tile.position.y) && ((tile.next) || (tile.previous == self.head))) {
                doesHit = true;
                break;
            }
            tile = tile.next;
        }
    } else {
        tile = self.head;
        while (tile) {
            if ((point.x == tile.position.x) && (point.y == tile.position.y)) {
                doesHit = true;
                break;
            }
            tile = tile.next;
        }
        
    }
    
    
    return doesHit;
}

- (NSArray<NSNumber *> *)inputs {
    
    bool returnDistance = true;
    bool separateTail = false;
    
    NSMutableArray *visionArray = [NSMutableArray new];
    NSPoint head = self.head.position;
    NSPoint food = self.food.position;
    NSPoint body[self.snakeLength];
    
    SnakeTile *tile = self.head.next;
    int index = 0;
    while (tile) {
        body[index] = tile.position;
        tile = tile.next;
        index++;
    }
    
    int x;
    if (separateTail) { x = 32; } else { x = 24; }
    
    double vision[32] = {0};
    
    //check distance to wall
    vision[0] = 1 / (head.y + 1);                           //n
    vision[1] = 1 / (self.width - head.x);                  //e
    vision[2] = 1 / (self.height - head.y);                 //s
    vision[3] = 1 / (head.x + 1);                           //w
    vision[4] = MAX(vision[0],vision[1]);                   //ne
    vision[5] = MAX(vision[1],vision[2]);                   //se
    vision[6] = MAX(vision[2],vision[3]);                   //sw
    vision[7] = MAX(vision[3],vision[0]);                   //nw

    //check for food
    
    /* if returnDistance is set to false, vision will contain 1 when an object
     is in its path and 0 when it is not. if set to true, vision will contain
     the inverse of the distance to the object. */
    
    if (!returnDistance) {
        if ((food.x == head.x) && (food.y < head.y)){           //n
            vision[8] = 1;
        } else if ((food.y == head.y) && (food.x > head.x)){    //e
            vision[9] = 1;
        } else if ((food.x == head.x) && (food.y > head.y)){    //s
            vision[10] = 1;
        } else if ((food.y == head.y) && (food.x < head.x)){    //w
            vision[11] = 1;
        } else if (abs((int)food.y - (int)head.y) == abs((int)food.x - (int)head.x)) {
            int yDist = (int)food.y - (int)head.y;
            int xDist = (int)food.x - (int)head.x;
            if ((yDist < 0) && (xDist > 0)) {                   //ne
                vision[12] = 1;
            } else if ((yDist > 0) && (xDist > 0)) {            //se
                vision[13] = 1;
            } else if ((yDist > 0) && (xDist < 0)) {            //sw
                vision[14] = 1;
            } else if ((yDist < 0) && (xDist < 0)) {            //nw
                vision[15] = 1;
            }
        }
    } else {
        if ((food.x == head.x) && (food.y < head.y)){           //n
            vision[8] = 1 / fabs(food.y - head.y);
        } else if ((food.y == head.y) && (food.x > head.x)){    //e
            vision[9] = 1 / fabs(food.x - head.x);
        } else if ((food.x == head.x) && (food.y > head.y)){    //s
            vision[10] = 1 / fabs(food.y - head.y);
        } else if ((food.y == head.y) && (food.x < head.x)){    //w
            vision[11] = 1 /  fabs(food.x - head.x);
        } else if (abs((int)food.y - (int)head.y) == abs((int)food.x - (int)head.x)) {
            
            double yDist = food.y - head.y;
            double xDist = food.x - head.x;
            if ((yDist < 0) && (xDist > 0)) {                   //ne
                vision[12] = 1 / fabs(xDist);
            } else if ((yDist > 0) && (xDist > 0)) {            //se
                vision[13] = 1 / fabs(xDist);
            } else if ((yDist > 0) && (xDist < 0)) {            //sw
                vision[14] = 1 / fabs(xDist);
            } else if ((yDist < 0) && (xDist < 0)) {            //nw
                vision[15] = 1 / fabs(xDist);
            }
        }
    }
    
    //check for body
    if (!separateTail) {
        for (int i = 0; i < self.snakeLength; i++) {
            if (!returnDistance) {
                if ((body[i].x == head.x) && (body[i].y < head.y)){           //n
                    vision[16] = 1;
                    NSLog(@"body north");
                } else if ((body[i].y == head.y) && (body[i].x > head.x)){    //e
                    vision[17] = 1;
                    NSLog(@"body east");
                } else if ((body[i].x == head.x) && (body[i].y > head.y)){    //s
                    vision[18] = 1;
                    NSLog(@"body south");
                } else if ((body[i].y == head.y) && (body[i].x < head.x)){    //w
                    vision[19] = 1;
                    NSLog(@"body west");
                } else if (abs((int)body[i].y - (int)head.y) == abs((int)body[i].x - (int)head.x)) {
                    int yDist = (int)body[i].y - (int)head.y;
                    int xDist = (int)body[i].x - (int)head.x;
                    if ((yDist < 0) && (xDist > 0)) {                   //ne
                        vision[20] = 1;
                        NSLog(@"body northeast");
                    } else if ((yDist > 0) && (xDist > 0)) {            //se
                        vision[21] = 1;
                        NSLog(@"body southeast");
                    } else if ((yDist > 0) && (xDist < 0)) {            //sw
                        vision[22] = 1;
                        NSLog(@"body southwest");
                    } else if ((yDist < 0) && (xDist < 0)) {            //nw
                        vision[23] = 1;
                        NSLog(@"body northwest");
                    }
                }
            } else {
                if ((body[i].x == head.x) && (body[i].y < head.y)){           //n
                    vision[16] = MAX(1 / fabs(body[i].y - head.y), vision[16]);
                } else if ((body[i].y == head.y) && (body[i].x > head.x)){    //e
                    vision[17] = MAX(1 / fabs(body[i].x - head.x), vision[17]);
                } else if ((body[i].x == head.x) && (body[i].y > head.y)){    //s
                    vision[18] = MAX(1 / fabs(body[i].y - head.y), vision[18]);
                } else if ((body[i].y == head.y) && (body[i].x < head.x)){    //w
                    vision[19] = MAX(1 / fabs(body[i].x - head.x), vision[19]);
                } else if (abs((int)body[i].y - (int)head.y) == abs((int)body[i].x - (int)head.x)) {
                    double yDist = body[i].y - head.y;
                    double xDist = body[i].x - head.x;
                    if ((yDist < 0) && (xDist > 0)) {                   //ne
                        vision[20] = MAX(1 / fabs(xDist), vision[20]);
                    } else if ((yDist > 0) && (xDist > 0)) {            //se
                        vision[21] = MAX(1 / fabs(xDist), vision[21]);
                    } else if ((yDist > 0) && (xDist < 0)) {            //sw
                        vision[22] = MAX(1 / fabs(xDist), vision[22]);
                    } else if ((yDist < 0) && (xDist < 0)) {            //nw
                        vision[23] = MAX(1 / fabs(xDist), vision[23]);
                    }
                }
            }
        }
    } else {
        for (int i = 0; i < self.snakeLength; i++) {
            if (!returnDistance) {
                if ((body[i].x == head.x) && (body[i].y < head.y)){           //n
                    vision[16] = 1;
                    NSLog(@"body north");
                } else if ((body[i].y == head.y) && (body[i].x > head.x)){    //e
                    vision[17] = 1;
                    NSLog(@"body east");
                } else if ((body[i].x == head.x) && (body[i].y > head.y)){    //s
                    vision[18] = 1;
                    NSLog(@"body south");
                } else if ((body[i].y == head.y) && (body[i].x < head.x)){    //w
                    vision[19] = 1;
                    NSLog(@"body west");
                } else if (abs((int)body[i].y - (int)head.y) == abs((int)body[i].x - (int)head.x)) {
                    int yDist = (int)body[i].y - (int)head.y;
                    int xDist = (int)body[i].x - (int)head.x;
                    if ((yDist < 0) && (xDist > 0)) {                   //ne
                        vision[20] = 1;
                        NSLog(@"body northeast");
                    } else if ((yDist > 0) && (xDist > 0)) {            //se
                        vision[21] = 1;
                        NSLog(@"body southeast");
                    } else if ((yDist > 0) && (xDist < 0)) {            //sw
                        vision[22] = 1;
                        NSLog(@"body southwest");
                    } else if ((yDist < 0) && (xDist < 0)) {            //nw
                        vision[23] = 1;
                        NSLog(@"body northwest");
                    }
                }
            } else {
                if ((body[i].x == head.x) && (body[i].y < head.y)){           //n
                    vision[16] = MAX(1 / fabs(body[i].y - head.y), vision[16]);
                } else if ((body[i].y == head.y) && (body[i].x > head.x)){    //e
                    vision[17] = MAX(1 / fabs(body[i].x - head.x), vision[17]);
                } else if ((body[i].x == head.x) && (body[i].y > head.y)){    //s
                    vision[18] = MAX(1 / fabs(body[i].y - head.y), vision[18]);
                } else if ((body[i].y == head.y) && (body[i].x < head.x)){    //w
                    vision[19] = MAX(1 / fabs(body[i].x - head.x), vision[19]);
                } else if (abs((int)body[i].y - (int)head.y) == abs((int)body[i].x - (int)head.x)) {
                    double yDist = body[i].y - head.y;
                    double xDist = body[i].x - head.x;
                    if ((yDist < 0) && (xDist > 0)) {                   //ne
                        vision[20] = MAX(1 / fabs(xDist), vision[20]);
                    } else if ((yDist > 0) && (xDist > 0)) {            //se
                        vision[21] = MAX(1 / fabs(xDist), vision[21]);
                    } else if ((yDist > 0) && (xDist < 0)) {            //sw
                        vision[22] = MAX(1 / fabs(xDist), vision[22]);
                    } else if ((yDist < 0) && (xDist < 0)) {            //nw
                        vision[23] = MAX(1 / fabs(xDist), vision[23]);
                    }
                }
            }
        }
        
        int i = self.snakeLength - 1;
        
        if (!returnDistance) {
            if ((body[i].x == head.x) && (body[i].y < head.y)){           //n
                vision[24] = 1;
                NSLog(@"body north");
            } else if ((body[i].y == head.y) && (body[i].x > head.x)){    //e
                vision[25] = 1;
                NSLog(@"body east");
            } else if ((body[i].x == head.x) && (body[i].y > head.y)){    //s
                vision[26] = 1;
                NSLog(@"body south");
            } else if ((body[i].y == head.y) && (body[i].x < head.x)){    //w
                vision[27] = 1;
                NSLog(@"body west");
            } else if (abs((int)body[i].y - (int)head.y) == abs((int)body[i].x - (int)head.x)) {
                int yDist = (int)body[i].y - (int)head.y;
                int xDist = (int)body[i].x - (int)head.x;
                if ((yDist < 0) && (xDist > 0)) {                   //ne
                    vision[28] = 1;
                    NSLog(@"body northeast");
                } else if ((yDist > 0) && (xDist > 0)) {            //se
                    vision[29] = 1;
                    NSLog(@"body southeast");
                } else if ((yDist > 0) && (xDist < 0)) {            //sw
                    vision[30] = 1;
                    NSLog(@"body southwest");
                } else if ((yDist < 0) && (xDist < 0)) {            //nw
                    vision[31] = 1;
                    NSLog(@"body northwest");
                }
            }
        } else {
            if ((body[i].x == head.x) && (body[i].y < head.y)){           //n
                vision[24] = MAX(1 / fabs(body[i].y - head.y), vision[16]);
            } else if ((body[i].y == head.y) && (body[i].x > head.x)){    //e
                vision[25] = MAX(1 / fabs(body[i].x - head.x), vision[17]);
            } else if ((body[i].x == head.x) && (body[i].y > head.y)){    //s
                vision[26] = MAX(1 / fabs(body[i].y - head.y), vision[18]);
            } else if ((body[i].y == head.y) && (body[i].x < head.x)){    //w
                vision[27] = MAX(1 / fabs(body[i].x - head.x), vision[19]);
            } else if (abs((int)body[i].y - (int)head.y) == abs((int)body[i].x - (int)head.x)) {
                double yDist = body[i].y - head.y;
                double xDist = body[i].x - head.x;
                if ((yDist < 0) && (xDist > 0)) {                   //ne
                    vision[28] = MAX(1 / fabs(xDist), vision[20]);
                } else if ((yDist > 0) && (xDist > 0)) {            //se
                    vision[29] = MAX(1 / fabs(xDist), vision[21]);
                } else if ((yDist > 0) && (xDist < 0)) {            //sw
                    vision[30] = MAX(1 / fabs(xDist), vision[22]);
                } else if ((yDist < 0) && (xDist < 0)) {            //nw
                    vision[31] = MAX(1 / fabs(xDist), vision[23]);
                }
            }
        }

        
    }
    
    
    for (int i = 0; i < x; i++){
        double currentVal = vision[i];
        
        if (currentVal == (int)floor(currentVal)){
            [visionArray addObject:[NSNumber numberWithInt:currentVal]];
        } else {
            [visionArray addObject:[NSNumber numberWithDouble:currentVal]];
        }
    }
    
    return [NSArray arrayWithArray:visionArray];
}

- (void)runGameFromReplay:(NSArray *)replay {
    self.gameActive = true;
    for (NSDictionary *state in replay) {
        self.food = [state objectForKey:@"food"];
        self.head = [state objectForKey:@"head"];
        self.snakeView.snakeHead = [state objectForKey:@"head"];
        self.snakeView.food = [state objectForKey:@"food"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.snakeView setNeedsDisplay:true];
        });
        [NSThread sleepForTimeInterval:0.02f];
    }
}

@end

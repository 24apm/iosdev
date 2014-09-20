//
//  BoardManager.m
//  Digger
//
//  Created by MacCoder on 9/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BoardManager.h"
#import "Utils.h"
#import "GridPoint.h"

@interface BoardManager()

@property (strong, nonatomic) BoardView *boardView;

@end

@implementation BoardManager

+ (BoardManager *)instance {
    static BoardManager *instance = nil;
    if (!instance) {
        instance = [[BoardManager alloc] init];
    }
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tiles = [NSMutableArray array];
        
    }
    return self;
}

- (void)setupWithBoard:(BoardView *)boardView {
    float blockWidth = boardView.width / NUM_COL;
    self.tileSize = CGSizeMake(blockWidth, blockWidth);
    
    self.boardView = boardView;
}

#pragma mark - board functions
- (TileView *)tileAtRow:(int)r column:(int)c {
    int index = r * NUM_COL + c;
    if (index >= 0  && index < self.tiles.count) {
        return [self.tiles objectAtIndex:index];
    } else {
        return nil;
    }
}

- (NSArray *)tilesAtRow:(int)r {
    return [self.tiles subarrayWithRange:NSMakeRange(r * NUM_COL, NUM_COL)];
}

- (GridPoint *)pointForTile:(TileView *)tileView {
    int index = [self.tiles indexOfObject:tileView];
    int r = index / NUM_COL;
    int c = index % NUM_COL;
    return [GridPoint gridPointWithRow:r col:c];
}

- (void)replaceBlock:(BlockView *)blockView onTile:(TileView *)tileView {
    [self removeBlockFrom:tileView];
    [self addBlock:blockView onTile:tileView];
}

- (void)removeBlockFrom:(TileView *)tileView {
    tileView.blockView.tileView = nil;
    [tileView.blockView removeFromSuperview];
    tileView.blockView = nil;
}

- (void)addBlock:(BlockView *)blockView onTile:(TileView *)tileView {
    tileView.blockView = blockView;
    blockView.frame = tileView.frame;
    blockView.tileView = tileView;
    [tileView.superview addSubview:blockView];
}

- (BOOL)isOccupied:(TileView *)tileView {
    return tileView.blockView != nil;
}

- (void)moveBlock:(BlockView *)blockView toTile:(TileView *)tileView {
    [self removeBlockFrom:blockView.tileView];      //  remove previous tile
    [self replaceBlock:blockView onTile:tileView];  //  move to new tile
}

- (void)movePlayerBlock:(TileView *)tileView {
    [self moveBlock:self.boardView.playerView toTile:tileView];
}


@end

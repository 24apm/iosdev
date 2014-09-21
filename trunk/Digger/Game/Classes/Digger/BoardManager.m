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
#import "TreasureView.h"
#import "PlayerView.h"
#import "ObstacleView.h"
#import "BlockView.h"
#import "PowerView.h"

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
        self.slots = [NSMutableArray array];
        
    }
    return self;
}

- (void)setupWithBoard:(BoardView *)boardView {
    float blockWidth = boardView.width / NUM_COL;
    self.slotSize = CGSizeMake(blockWidth, blockWidth);
    
    self.boardView = boardView;
}

#pragma mark - board functions
- (SlotView *)slotAtRow:(NSUInteger)r column:(NSUInteger)c {
    NSUInteger index = r * NUM_COL + c;
    if (index < self.slots.count) {
        return [self.slots objectAtIndex:index];
    } else {
        return nil;
    }
}

- (NSArray *)slotsAtRow:(NSUInteger)r {
    return [self.slots subarrayWithRange:NSMakeRange(r * NUM_COL, NUM_COL)];
}

- (GridPoint *)pointForSlot:(SlotView *)slotView {
    NSUInteger index = [self.slots indexOfObject:slotView];
    NSUInteger r = index / NUM_COL;
    NSUInteger c = index % NUM_COL;
    return [GridPoint gridPointWithRow:r col:c];
}

- (void)replaceBlock:(BlockView *)blockView onSlot:(SlotView *)slotView {
    [self removeBlockFrom:slotView];
    [self addBlock:blockView onSlot:slotView];
}

- (void)removeBlockFrom:(SlotView *)slotView {
    slotView.blockView.slotView = nil;
    [slotView.blockView removeFromSuperview];
    slotView.blockView = nil;
}

- (void)addBlock:(BlockView *)blockView onSlot:(SlotView *)slotView {
    slotView.blockView = blockView;
    blockView.size = slotView.size;
    blockView.slotView = slotView;
    [slotView addSubview:blockView];
}

- (BOOL)isOccupied:(SlotView *)slotView {
    return slotView.blockView != nil;
}

- (void)moveBlock:(BlockView *)blockView toSlot:(SlotView *)slotView {
    [self removeBlockFrom:blockView.slotView];      //  remove previous slot
    [self replaceBlock:blockView onSlot:slotView];  //  move to new slot
}

- (void)movePlayerBlock:(SlotView *)slotView {
    [self moveBlock:self.boardView.playerView toSlot:slotView];
}

- (BlockView *)blockViewForType:(BlockType)currentType {
    
    BlockView *blockView;
    
    switch (currentType) {
        case BlockTypeObstacle: {
            blockView = [[ObstacleView alloc] init];
            blockView.type = currentType;
            break;
        }
        case BlockTypePower: {
            blockView = [[PowerView alloc] init];
            blockView.type = currentType;
            break;
        }
        case BlockTypeTreasure: {
            blockView = [[TreasureView alloc] init];
            blockView.type = currentType;
            break;
        }
        default: {
            blockView = [[BlockView alloc] init];
            blockView.type = currentType;
            break;
        }
    }
    return blockView;
}

@end

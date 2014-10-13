//
//  BoardManager.h
//  Digger
//
//  Created by MacCoder on 9/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameConstants.h"
#import "SlotView.h"
#import "BoardView.h"
#import "PlayerView.h"

#define NUM_COL 5
#define NUM_ROW 10
#define MARGIN_BLOCK 10 * IPAD_SCALE

@class GridPoint;
@class BoardView;
@class SlotView;
@class BlockView;

@interface BoardManager : NSObject

+ (BoardManager *)instance;
- (void)setupWithBoard:(BoardView *)boardView;

- (SlotView *)slotAtRow:(NSUInteger)r column:(NSUInteger)c;
- (NSArray *)slotsAtRow:(NSUInteger)r;
- (GridPoint *)pointForSlot:(SlotView *)slotView;

- (BOOL)isOccupied:(SlotView *)slotView;

- (void)moveBlock:(BlockView *)blockView toSlot:(SlotView *)slotView;
- (void)movePlayerBlock:(SlotView *)slotView;

- (BlockView *)blockViewForType:(BlockType)currentType;

- (NSUInteger)checkCurrentDepth;

@property (nonatomic) CGSize slotSize;
@property (strong, nonatomic) NSArray *slots;


@end

//
//  BoardView.h
//  Vocabulary
//
//  Created by MacCoder on 10/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "LevelData.h"
#import "BlockView.h"

@class SlotView;

#define NUM_COL 10
#define NUM_ROW 11
#define MIN_SIZE_TO_MATCH 3
#define NO_MORE_MOVE @"NO_MORE_MOVE"

@interface BoardView : UIView

@property (nonatomic) CGSize slotSize;
@property (strong, nonatomic) NSMutableArray *slotSelection;
@property (nonatomic) BOOL hasCorrectMatch;
@property (strong, nonatomic) LevelData *levelData;
@property (nonatomic) NSInteger colPointer;

- (void)setupWithLevel:(LevelData *)levelData;
- (SlotView *)slotAtRow:(NSInteger)r column:(NSInteger)c;
- (NSString *)buildStringFromArray:(NSArray *)slotSelection;
- (void)placeBlockLine;
- (void)shiftBlocksDown;
- (void)destroyBlocksForType:(BlockType)type;

@end

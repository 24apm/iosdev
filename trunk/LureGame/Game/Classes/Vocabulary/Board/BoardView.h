//
//  BoardView.h
//  Vocabulary
//
//  Created by MacCoder on 10/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "LevelData.h"

@class SlotView;

#define NOTIFICATION_WORD_MATCHED @"NOTIFICATION_WORD_MATCHED"

@interface BoardView : UIView

@property (nonatomic) CGSize slotSize;
@property (strong, nonatomic) NSMutableArray *slotSelection;
@property (nonatomic) BOOL hasCorrectMatch;
@property (strong, nonatomic) LevelData *levelData;
@property (strong, nonatomic) SlotView *characterSlot;

- (BOOL)isThereTargetSlot;
- (void)setupWithLevel:(LevelData *)levelData;
- (SlotView *)slotAtRow:(NSInteger)r column:(NSInteger)c;
- (void)moveCharacterTo:(SlotView *)targetSlot;
- (SlotView *)currentTarget;

@end

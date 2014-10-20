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

- (void)setupWithLevel:(LevelData *)levelData;
- (void)showAnswer;
- (SlotView *)slotAtRow:(NSInteger)r column:(NSInteger)c;

@end

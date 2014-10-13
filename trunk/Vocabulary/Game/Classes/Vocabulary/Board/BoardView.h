//
//  BoardView.h
//  Vocabulary
//
//  Created by MacCoder on 10/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "LevelData.h"

#define NOTIFICATION_WORD_MATCHED @"NOTIFICATION_WORD_MATCHED"

@interface BoardView : UIView

@property (nonatomic) CGSize slotSize;
@property (strong, nonatomic) NSMutableArray *slotSelection;
@property (nonatomic) BOOL hasCorrectMatch;

- (void)setupWithLevel:(LevelData *)levelData;

@end

//
//  FoundWordDialogView.h
//  Vocabulary
//
//  Created by MacCoder on 10/31/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimatingDialogView.h"
#define GAME_END @"GAME_END"
#define GAME_END_NEW @"GAME_END_NEW"
#define START_NEW_GAME_NOTIFICATION @"START_NEW_GAME_NOTIFICATION"
#define OPEN_BOOK_NOTIFICATION @"OPEN_BOOK_NOTIFICATION"

typedef void (^BLOCK)(void);

@interface CompletedLevelDialogView : AnimatingDialogView

- (id)initForState:(NSString *)state;

@end

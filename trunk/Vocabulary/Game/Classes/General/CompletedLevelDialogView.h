//
//  FoundWordDialogView.h
//  Vocabulary
//
//  Created by MacCoder on 10/31/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimatingDialogView.h"

typedef void (^BLOCK)(void);

@interface CompletedLevelDialogView : AnimatingDialogView

- (id)initWithCallback:(BLOCK)callback;

@end

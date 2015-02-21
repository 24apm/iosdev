//
//  UserChoice.h
//  StackGame
//
//  Created by MacCoder on 1/17/15.
//  Copyright (c) 2015 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "ButtonBase.h"
#import "BlockView.h"

#define USER_CHOICE_PRESSED @"USER_CHOICE_PRESSED"
@interface UserChoice : XibView

@property (strong, nonatomic) IBOutlet ButtonBase *label;
@property (nonatomic) BlockType blockID;
- (void)setChoiceID:(BlockType)type;
@end

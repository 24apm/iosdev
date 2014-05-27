//
//  BonusButton.m
//  Clicker
//
//  Created by MacCoder on 5/21/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BonusButton.h"
#import "UserData.h"

@implementation BonusButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)buttonpressed:(UIButton *)sender {
    self.currentRewardPoints = [[UserData instance] totalPointPerTap:NO] * 50;
    [[NSNotificationCenter defaultCenter]postNotificationName:BONUS_BUTTON_TAPPED_NOTIFICATION object:self];
    [self removeFromSuperview];
}
@end

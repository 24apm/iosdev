//
//  BonusButton.h
//  Clicker
//
//  Created by MacCoder on 5/21/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

#define BONUS_BUTTON_TAPPED_NOTIFICATION @"BONUS_BUTTON_TAPPED_NOTIFICATION"

@interface BonusButton : XibView

@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic) float currentRewardPoints;

@end

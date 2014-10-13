//
//  ChoiceDialogView.m
//  Digger
//
//  Created by MacCoder on 10/8/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ChoiceDialogView.h"
#import "GameConstants.h"

@implementation ChoiceDialogView

- (id)init {
    self = [super init];
    if (self) {
        self.headerLabel.text = @"Your knapsack is FULL!";
        self.bodyLabel.text = @"Do you want to drop an item in your knapsack to make space?";
    }
    return self;
}

- (IBAction)noButtonPressed:(UIButton *)sender {
    [self dismissed:sender];
}

- (IBAction)yesButtonPressed:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:REMOVING_ITEM_FOR_SPACE_NOTIFICATION object:nil];
    [self dismissed:sender];
}

@end

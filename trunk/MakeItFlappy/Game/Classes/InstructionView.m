//
//  instructionView.m
//  Make It Flappy
//
//  Created by MacCoder on 7/2/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "InstructionView.h"
#import "GameConstants.h"

@implementation InstructionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)show {
    [super show];
    [[NSNotificationCenter defaultCenter]postNotificationName:UPGRADE_VIEW_OPEN_NOTIFICATION object:nil];
}

- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:sender];
}

- (IBAction)closeButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:UPGRADE_VIEW_CLOSED_NOTIFICATION object:nil];
    [self dismissed:self];
}
@end

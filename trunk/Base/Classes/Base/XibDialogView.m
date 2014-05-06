//
//  XibDialogView.m
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibDialogView.h"
#import "Utils.h"
#import "DialogViewManager.h"

@implementation XibDialogView

- (void)show {
    [[DialogViewManager instance] show:self];
}

- (void)showWithNoOverlay {
    [[DialogViewManager instance] showWithNoOverlay:self];
}

- (IBAction)dismissed:(id)sender {
    [[DialogViewManager instance] dismissed:self];
}

@end

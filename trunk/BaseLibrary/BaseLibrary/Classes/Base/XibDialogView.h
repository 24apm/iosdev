//
//  XibDialogView.h
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "Utils.h"

@interface XibDialogView : XibView

- (IBAction)dismissed:(id)sender;
- (void)show;
- (void)showWithNoOverlay;

@end

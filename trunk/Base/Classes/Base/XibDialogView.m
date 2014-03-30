//
//  XibDialogView.m
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibDialogView.h"
#import "Utils.h"

@implementation XibDialogView

- (void)show {
    [[Utils rootViewController].view addSubview:self];
}

- (IBAction)dismissed:(id)sender {
    [self removeFromSuperview];
}

@end
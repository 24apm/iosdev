//
//  VisitorView.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VisitorView.h"
#import "VisitorManager.h"

NSString *const VisitorViewRefreshNotification = @"VisitorViewRefreshNotification";

@implementation VisitorView

- (void)setupWithData:(VisitorData *)data {
    self.data = data;
    [self.imageButton setBackgroundImage:[UIImage imageNamed:data.imagePath] forState:UIControlStateNormal];
}

- (IBAction)buttonPressed:(id)sender {
    XibDialogView *dialog = [[VisitorManager instance] dialogFor:self.data];
    [dialog show];
    self.data = nil;
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:VisitorViewRefreshNotification object:self];
}

@end

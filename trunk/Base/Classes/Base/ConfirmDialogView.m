//
//  ConfirmDialogView.m
//  Weed
//
//  Created by MacCoder on 7/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ConfirmDialogView.h"

@implementation ConfirmDialogView

- (id)initWithHeaderText:(NSString *)headerText
                bodyText:(NSString *)bodyText
              yesPressed:(BLOCK)yesPressed
               noPressed:(BLOCK)noPressed {
    self = [super initWithHeaderText:headerText bodyText:bodyText];
    if (self) {
        self.yesPressedSelector = yesPressed;
        self.noPressedSelector = noPressed;
    }
    return self;
}

- (IBAction)yesPressed:(id)sender {
    if (self.yesPressedSelector) {
        self.yesPressedSelector();
    }
    [self dismissed:self];
}

- (IBAction)noPressed:(id)sender {
    if (self.noPressedSelector) {
        self.noPressedSelector();
    }
    [self dismissed:self];
}

@end

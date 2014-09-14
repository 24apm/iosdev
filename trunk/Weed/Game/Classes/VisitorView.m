//
//  VisitorView.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VisitorView.h"
#import "VisitorManager.h"
#import "RealEstateManager.h"
#import "Utils.h"
#import "GameLoopTimer.h"
#import "ConfirmDialogView.h"
#import "NSBundle+BundleUtil.h"

@implementation VisitorView

- (void)setupWithData:(VisitorData *)data {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateOut) object:nil];
    self.data = data;
    //[self.imageButton setBackgroundImage:[UIImage myLibraryImageNamed:data.imagePath] forState:UIControlStateNormal];
    [self.imageButton setBackgroundImage:[UIImage imageNamed:@"renterunknown"] forState:UIControlStateNormal];
    [self performSelector:@selector(animateOut) withObject:nil afterDelay:[Utils randBetweenMin:20.f max:30.f]];
    
    self.messageBubbleLabel.text = data.messageBubble;
}

- (IBAction)buttonPressed:(id)sender {
    if ([RealEstateManager instance].state == RealEstateManagerStateNormal) {
        ConfirmDialogView *dialog = [[VisitorManager instance] dialogFor:self.data];
//        dialog.yesPressedSelector = ^ {
//            [self animateOut];
//        };
        [self animateOut];

        [dialog show];
    }
}

- (void)animateIn {
    self.hidden = NO;
    self.alpha = 0.f;
    [UIView animateWithDuration:0.5f animations:^ {
        self.alpha = 1.f;
    } completion:^(BOOL completed) {
        
    }];
}

- (void)animateOut {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateOut) object:nil];
    [UIView animateWithDuration:0.5f animations:^ {
        self.alpha = 0.f;
    } completion:^(BOOL completed) {
        self.data = nil;
    }];
}

@end

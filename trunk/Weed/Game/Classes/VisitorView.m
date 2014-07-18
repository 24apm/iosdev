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

@implementation VisitorView

- (void)setupWithData:(VisitorData *)data {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateOut) object:nil];
    self.data = data;
    [self.imageButton setBackgroundImage:[UIImage imageNamed:data.imagePath] forState:UIControlStateNormal];
    [self performSelector:@selector(animateOut) withObject:nil afterDelay:[Utils randBetweenMin:30.f max:60.f]];
}

- (IBAction)buttonPressed:(id)sender {
    if ([RealEstateManager instance].state == RealEstateManagerStateNormal) {
        XibDialogView *dialog = [[VisitorManager instance] dialogFor:self.data];
        [dialog show];
        [self animateOut];
    }
}

- (void)animateIn {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateOut) object:nil];
    self.hidden = NO;
    self.transform = CGAffineTransformMakeTranslation(self.width * 2, 0);
    [UIView animateWithDuration:0.5f animations:^ {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL completed) {
        
    }];
}

- (void)animateOut {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateOut) object:nil];
    [UIView animateWithDuration:0.5f animations:^ {
        self.transform = CGAffineTransformMakeTranslation(self.width * 2, 0);
    } completion:^(BOOL completed) {
        self.hidden = YES;
        self.data = nil;
    }];
}

@end

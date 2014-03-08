//
//  InGameMessageView.m
//  NumberGame
//
//  Created by MacCoder on 2/23/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "InGameMessageView.h"

@implementation InGameMessageView

- (void)show {
    self.hidden = NO;
    self.alpha = 1.0f;
    
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        } completion:^(BOOL completed) {
            [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform = CGAffineTransformMakeScale(1.01f, 1.01f);
            } completion:^(BOOL completed) {
                [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.transform = CGAffineTransformMakeScale(2.00f, 2.00f);
                    self.alpha = 0.f;
                } completion:^(BOOL completed) {
                    self.transform = CGAffineTransformIdentity;
                    self.hidden = YES;
                    self.alpha = 1.0f;
                }];
            }];
        }];
    }];
}

- (void)hide {
    
}

@end

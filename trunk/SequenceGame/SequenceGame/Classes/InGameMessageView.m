//
//  InGameMessageView.m
//  NumberGame
//
//  Created by MacCoder on 2/23/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "InGameMessageView.h"

@implementation InGameMessageView

- (id)init {
    self = [super init];
    if (self) {
        self.imageView.hidden = YES;
        self.label.hidden = YES;
    }
    return self;
}

- (void)showImage:(NSString *)imageName {
    self.imageView.image = [UIImage imageNamed:imageName];
    self.imageView.hidden = NO;
    [self show];
}

- (void)show:(NSString *)text {
    self.label.text = text;
    self.label.hidden = NO;
    [self show];
}

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
                    [self hide];
                }];
            }];
        }];
    }];
}

- (void)hide {
    self.transform = CGAffineTransformIdentity;
    self.hidden = YES;
    self.alpha = 1.0f;
    self.imageView.hidden = YES;
    self.label.hidden = YES;
}

@end

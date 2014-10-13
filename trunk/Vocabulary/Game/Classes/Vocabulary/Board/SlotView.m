//
//  SlotView.m
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "SlotView.h"

@implementation SlotView

- (void)animateLabelSelection {
    [self.labelView.layer removeAllAnimations];
    
    CGFloat doubleDigits[10] = {0.f, 0.3f, 0.0, 0.2f, 0.f,
                                0.1f, 0.f, 0.05f, 0, 0};
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    NSMutableArray *values = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        CGFloat height = -doubleDigits[i] * self.height;
        [values addObject:@(height)];
    }
    
    keyFrameAnimation.values = values;
    keyFrameAnimation.duration = 1.f;
    [self.labelView.layer addAnimation:keyFrameAnimation forKey:@"bounce"];
}

@end

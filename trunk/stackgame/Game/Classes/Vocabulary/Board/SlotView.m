//
//  SlotView.m
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "SlotView.h"

@implementation SlotView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.block = [[BlockView alloc]init];
        [self addSubview:self.block];
        self.block.hidden = YES;
    }
    return self;
}



//- (void)animateLabelSelection {
//    [self.labelView.layer removeAllAnimations];
//    
//    CGFloat doubleDigits[7] = {0.f, 0.2f, 0.0, 0.1f, 0.f,
//                                0.05f, 0.f};
//    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
//    NSMutableArray *values = [NSMutableArray array];
//    
//    for (NSInteger i = 0; i < 7; i++) {
//        CGFloat height = -doubleDigits[i] * self.height;
//        [values addObject:@(height)];
//    }
//    
//    keyFrameAnimation.values = values;
//    keyFrameAnimation.duration = 0.8f;
//    [self.labelView.layer addAnimation:keyFrameAnimation forKey:@"bounce"];
//}

@end

//
//  FoundWordDialogView.m
//  Vocabulary
//
//  Created by MacCoder on 10/31/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CompletedLevelDialogView.h"

@interface CompletedLevelDialogView()

@property (nonatomic, strong) BLOCK block;

@end

@implementation CompletedLevelDialogView

- (id)initWithCallback:(BLOCK)callback; {
    self = [super init];
    if (self) {
        self.block = callback;
    }
    return self;
}


- (IBAction)nextPressed:(id)sender {
    self.block();
    [self dismissed:self];
}

//- (void)popIn:(UIView *)view {
//    CAKeyframeAnimation *popIn = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    popIn.values = @[@(0.f), @(1.2f), @(0.9f), @(1.0f)];
//    popIn.duration = 1.0f;
//    [view.layer addAnimation:popIn forKey:@"popIn"];
//    
//    CGFloat rotations = 3;
//    CGFloat duration = 1;
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
//    rotationAnimation.duration = duration;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = YES;
//    
//    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//}

@end

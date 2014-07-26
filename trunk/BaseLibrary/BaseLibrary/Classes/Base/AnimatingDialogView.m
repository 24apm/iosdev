//
//  AnimatingDialogView.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimatingDialogView.h"

@implementation AnimatingDialogView

- (void)show {
    [super show];
    [self popIn:self];
}

- (IBAction)dismissed:(id)sender {
    [self popOut:self];
    self.userInteractionEnabled = NO;
    [self performSelector:@selector(dismissView:) withObject:self afterDelay:0.1f];
}

- (void)popIn:(UIView *)view {
    CAKeyframeAnimation *popIn = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    popIn.values = @[@(0.f), @(1.2f), @(0.9f), @(1.0f)];
    popIn.duration = 0.3f;
    [view.layer addAnimation:popIn forKey:@"popIn"];
}

- (void)popOut:(UIView *)view {
    CAKeyframeAnimation *animateScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animateScale.values = @[@(1.f), @(0.f)];
    animateScale.duration = 0.1f;
    animateScale.removedOnCompletion = NO;
    animateScale.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animateScale forKey:@"animateScaleOut"];
}

- (void)dismissView:(XibDialogView *)dialogView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissView:) object:nil];
    self.userInteractionEnabled = YES;
    [super dismissed:self];
}

@end

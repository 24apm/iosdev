//
//  ErrorDialogView.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ErrorDialogView.h"

@implementation ErrorDialogView

- (void)show {
    [super show];
    [self animateIn];
}

- (void)animateIn {
    CABasicAnimation *animateAlpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateAlpha.fromValue = @(0.f);
    animateAlpha.toValue = @(1.f);
    animateAlpha.duration = 0.2f;
    [self.layer addAnimation:animateAlpha forKey:@"alphaIn"];
    
    CAKeyframeAnimation *popIn = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    popIn.values = @[@(0.f), @(1.2f), @(0.9f), @(1.0f)];
    popIn.duration = 0.3f;
    [self.contentView.layer addAnimation:popIn forKey:@"popIn"];
}

- (void)animateOut {
    CABasicAnimation *animateAlpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateAlpha.fromValue = @(1.f);
    animateAlpha.toValue = @(0.f);
    animateAlpha.duration = 0.2f;
    animateAlpha.removedOnCompletion = NO;
    animateAlpha.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animateAlpha forKey:@"alphaOut"];
    
    CAKeyframeAnimation *animateScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animateScale.values = @[@(1.f), @(0.f)];
    animateScale.duration = 0.3f;
    animateScale.removedOnCompletion = NO;
    animateScale.fillMode = kCAFillModeForwards;
    [self.contentView.layer addAnimation:animateScale forKey:@"animateScaleOut"];
}

- (IBAction)closePressed:(id)sender {
    [self animateDismissOut];
}

- (void)animateDismissOut {
    [self animateOut];
    [self performSelector:@selector(dismissView) withObject:nil afterDelay:0.3f];
}

- (void)dismissView {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:self];
}

@end

//
//  AnimatedLabel.m
//  2048
//
//  Created by MacCoder on 4/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimatedLabel.h"
#import "GameConstants.h"

@implementation AnimatedLabel

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)animate {
    self.hidden = YES;
    [self performSelector:@selector(_animate) withObject:nil afterDelay:.1];
}

- (void)animateSlow {
    self.hidden = YES;
    [self performSelector:@selector(_animateSlow) withObject:nil afterDelay:.1];
}

- (void)_animateSlow{
    self.hidden = NO;
    float offset = self.y - (1 * self.height);
    self.alpha = 1.f;
    
    CABasicAnimation *animatePosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animatePosition.toValue = [NSNumber valueWithCGPoint:CGPointMake(self.center.x, offset)];
    
    CABasicAnimation *animateAlpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateAlpha.toValue = [NSNumber numberWithFloat:0.0f];
    
    CAKeyframeAnimation *scaleIn = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleIn.values = @[@(1.0f),@(1.2f),@(1.0f)];
    scaleIn.keyTimes = @[@(0.0f),@(0.15f),@(0.3f)];
    
    CAAnimationGroup *animateGroup = [CAAnimationGroup animation];
    animateGroup.animations = [NSArray arrayWithObjects:animatePosition, scaleIn, animateAlpha, nil];
    animateGroup.duration = 3.f;
    animateGroup.fillMode = kCAFillModeForwards;
    animateGroup.removedOnCompletion = NO;
    [self.layer addAnimation:animateGroup forKey:@"animateGroup"];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:animateGroup.duration + 0.1f];
    
}

- (void)_animate {
    self.hidden = NO;
    float offset = self.y - (1 * self.height/3);
    self.alpha = 1.f;

    CABasicAnimation *animatePosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animatePosition.toValue = [NSNumber valueWithCGPoint:CGPointMake(self.center.x, offset)];
    
    CABasicAnimation *animateAlpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateAlpha.toValue = [NSNumber numberWithFloat:0.0f];
    
    CAKeyframeAnimation *scaleIn = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleIn.values = @[@(1.0f),@(1.2f),@(1.0f)];
    scaleIn.keyTimes = @[@(0.0f),@(0.15f),@(0.3f)];

    CAAnimationGroup *animateGroup = [CAAnimationGroup animation];
    animateGroup.animations = [NSArray arrayWithObjects:animatePosition, scaleIn, animateAlpha, nil];
    animateGroup.duration = 1.8f;
    animateGroup.fillMode = kCAFillModeForwards;
    animateGroup.removedOnCompletion = NO;
    [self.layer addAnimation:animateGroup forKey:@"animateGroup"];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:animateGroup.duration + 0.1f];

}

@end

//
//  UpgradeResultView.m
//  Make It Flappy
//
//  Created by MacCoder on 6/21/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UpgradeResultView.h"
#import "GameConstants.h"

@implementation UpgradeResultView

- (void)showSuccess {
    [super show];
    self.backgroundOverView.hidden = YES;
    [self animatingResult:@"character_learningsuccess"];
}

- (void)showFail {
    [super show];
    self.backgroundOverView.hidden = YES;
    [self animatingResult:@"character_learningfail"];
    
}

- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:SUCCESS_UPGRADE_ANIMATION_FINISH_NOTIFICATION object:nil];
    [super dismissed:sender];
}

- (void)animatingResult:(NSString *)imgName {
    NSString *img = imgName;
    UIImageView* upgradeProcess = [[UIImageView alloc] initWithFrame:self.imgView.frame];
    upgradeProcess.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"character_learning1"],
                                      [UIImage imageNamed:@"character_learning2"],
                                      [UIImage imageNamed:@"character_learning1"],
                                      [UIImage imageNamed:@"character_learning2"],
                                      [UIImage imageNamed:@"character_learning3"],
                                      [UIImage imageNamed:@"character_learning4"],
                                      [UIImage imageNamed:@"character_learning3"],
                                      [UIImage imageNamed:@"character_learning4"],
                                      [UIImage imageNamed:@"character_learning1"],
                                      [UIImage imageNamed:@"character_learning2"],
                                      [UIImage imageNamed:@"character_learning1"],
                                      [UIImage imageNamed:@"character_learning2"],nil];
    
    // all frames will execute in 1.75 seconds
    upgradeProcess.animationDuration = 2.75;
    // repeat the annimation forever
    upgradeProcess.animationRepeatCount = 1;
    // start animating
    [upgradeProcess startAnimating];
    // add the animation view to the main window
    [self addSubview:upgradeProcess];
    [self performSelector:@selector(finalFrame:) withObject:img afterDelay:upgradeProcess.animationDuration];
}

- (void)finalFrame:(NSString *)img {
    [self.imgView stopAnimating];
    self.imgView.layer.opacity = 0.f;
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    [groupAnimation setAnimations:[NSArray arrayWithObjects:fadeIn, nil]];
    [groupAnimation setDuration:1.f];
    [groupAnimation setRemovedOnCompletion:NO];
    [groupAnimation setFillMode:kCAFillModeForwards];
    [self.imgView.layer addAnimation:groupAnimation forKey:@"animateIn"];
    self.imgView.image = [UIImage imageNamed:img];
    [self performSelector:@selector(finalFrameFade:) withObject:nil afterDelay:1.8f];
}

- (void)finalFrameFade:(NSString *)img {
    //[self.imgView stopAnimating];
    
    self.imgView.layer.opacity = 1.f;
    
    CGPoint toPoint;
    toPoint.x = self.width;
    toPoint.y = self.height/2;
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.toValue = [NSNumber numberWithFloat:0.0f];
    
    CABasicAnimation *position = [CABasicAnimation animationWithKeyPath:@"position"];
    position.toValue = [NSNumber valueWithCGPoint:toPoint];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * .8f];
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    [groupAnimation setAnimations:[NSArray arrayWithObjects:fadeOut, rotationAnimation, position, nil]];
    [groupAnimation setDuration:.5f];
    [groupAnimation setRemovedOnCompletion:NO];
    [groupAnimation setFillMode:kCAFillModeForwards];
    [self.imgView.layer addAnimation:groupAnimation forKey:@"animateOut"];
    [self performSelector:@selector(dismissed:) withObject:nil afterDelay:.5f];
}

@end

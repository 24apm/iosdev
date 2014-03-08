//
//  MenuView.m
//  NumberGame
//
//  Created by MacCoder on 2/8/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "MainView.h"
#import "iRate.h"
#import "GameCenterHelper.h"
#import "GameConstants.h"

@implementation MainView

- (id)init {
    self = [super init];
    if (self) {
        self.resetButton.hidden = !DEBUG_MODE;
    }
    return self;
}

- (IBAction)startButtonPressed:(id)sender {
    [self hide];
}

- (IBAction)leaderboardPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_LEADERBOARD_NOTIFICATION object:self];
}
- (IBAction)achievementPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_ACHIEVEMENT_NOTIFICATION object:self];
}

- (IBAction)resetAchievements:(id)sender {
    [[GameCenterHelper instance].gameCenterManager resetAchievements];
}

- (void)show {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }];
    
    CGPoint startPoint = self.titleView.center;
    startPoint.y -= 0.1f * self.titleView.height;
    
    CGPoint endPoint = self.titleView.center;
    endPoint.y += 0.1f * self.titleView.height;
    
    CABasicAnimation *titleAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    titleAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    titleAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    titleAnimation.duration = 0.5f;
    titleAnimation.autoreverses = YES;
    titleAnimation.repeatCount = INFINITY;
    [self.titleView.layer addAnimation:titleAnimation forKey:@"position"];

}

- (void)hide {
    [self.titleView.layer removeAllAnimations];
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
        self.alpha = 0.0f;
    } completion:^(BOOL complete) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MAIN_VIEW_DISMISSED_NOTIFICATION object:self];
    }];
}


@end

//
//  ResultView.m
//  NumberGame
//
//  Created by MacCoder on 2/8/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ResultView.h"
#import <Social/Social.h>
#import "AnimUtil.h"
#import "iRate.h"
#import "UserData.h"
#import "NumberGameIAPHelper.h"
#import "GameCenterHelper.h"
#import "SoundManager.h"
#import "GameConstants.h"

@interface ResultView()

#define RESULT_VIEW_SCORE_LABEL_ANIMATION_TOTAL_DURATION 0.8f
#define RESULT_VIEW_SCORE_LABEL_ANIMATION_STEP_DURATION 0.05f
#define RESULT_VIEW_VIEW_TOTAL_DURATION 0.3f

@end

@implementation ResultView

- (void)show {
    self.achievementLabel.hidden = YES;
    self.fadeOverlay.hidden = YES;
    self.imgView.hidden = YES;
    self.y = self.height;
    
    [UIView animateWithDuration:RESULT_VIEW_VIEW_TOTAL_DURATION * 0.9f animations:^{
        self.y = -self.height * 0.05f;
    } completion:^(BOOL complete) {
        [UIView animateWithDuration:RESULT_VIEW_VIEW_TOTAL_DURATION * 0.1f animations:^{
            self.y = 0.f;
        } completion:^(BOOL complete) {
            [self animateAchievemnt];
        }];
    }];    
}

- (void)hide {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.3f animations:^{
        self.y = self.height;
    } completion:^(BOOL complete) {
        self.hidden = YES;
    }];
}

- (void)animateAchievemnt {
    self.fadeOverlay.hidden = NO;
    self.imgView.hidden = NO;
    
    // offscreen at bottom
    self.imgView.y = self.height;
    self.fadeOverlay.alpha = 0.f;
    [[SoundManager instance] play:SOUND_EFFECT_WINNING];

    [UIView animateWithDuration:0.3f
                          delay:0.3f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                              // animate fading in
                         self.fadeOverlay.alpha = 1.0f;
                          } completion:nil];
    
    [UIView animateWithDuration:0.3f
                          delay:0.8f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         // animate achievement to center
                         self.imgView.center = self.center;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^ {
                                              // animate fading in
                                              self.achievementLabel.hidden = NO;
                                              self.imgView.transform = CGAffineTransformMakeScale(1.4f, 1.4f);
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.3f
                                                                    delay:1.0f
                                                                  options:UIViewAnimationOptionCurveEaseInOut
                                                               animations:^ {
                                                                   // animate fading in
                                                                   self.imgView.transform = CGAffineTransformIdentity;
                                                               } completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.3f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveEaseInOut
                                                                                    animations:^ {
                                                                                        // animate fading in
                                                                                        self.achievementLabel.hidden = YES;
                                                                                        self.imgView.y = -self.imgView.height;                                                                                    } completion:^(BOOL finished) {
                                                                                            [UIView animateWithDuration:0.3f
                                                                                                                  delay:0.3f
                                                                                                                options:UIViewAnimationOptionCurveEaseInOut
                                                                                                             animations:^ {
                                                                                                                 // animate fading in
                                                                                                                 self.fadeOverlay.alpha = 0.0f;
                                                                                                             } completion:^(BOOL finished) {
                                                                                                                 self.fadeOverlay.hidden = YES;
                                                                                                                 self.imgView.hidden = YES;
                                                                                                                 self.userInteractionEnabled = YES;
                                                                                                                 [self hide];

                                                                                                                 }];
                                                                                    }];
                                                               }];
                                          }];
                     }];
    

}


@end

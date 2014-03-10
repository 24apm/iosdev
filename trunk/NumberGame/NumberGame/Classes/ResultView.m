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
#import "NumberManager.h"

@interface ResultView()

#define RESULT_VIEW_SCORE_LABEL_ANIMATION_TOTAL_DURATION 0.8f
#define RESULT_VIEW_SCORE_LABEL_ANIMATION_STEP_DURATION 0.05f
#define RESULT_VIEW_VIEW_TOTAL_DURATION 0.3f

@property NSTimer *timer;
@property (nonatomic) int currentScore;
@property (nonatomic) int step;
@property (nonatomic) int targetScore;

@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) NSArray *products;

@end

@implementation ResultView

- (IBAction)playAgainPressed:(id)sender {
    [self hide];
}

- (void)show {
    self.achievementLabel.hidden = YES;
    self.reachedLabel.hidden = YES;
    self.fadeOverlay.hidden = YES;
    self.imgView.hidden = YES;
    self.y = self.height;
    self.playButton.enabled = NO;
    self.recordLabel.hidden = YES;
    self.currentScore = 0;
    self.lastMaxScore = [UserData instance].maxScore;
    self.targetScore = [UserData instance].score;
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%d", self.currentScore];
    self.maxScoreLabel.text = [NSString stringWithFormat:@"%d", self.lastMaxScore];
    self.step = ceil((float)self.targetScore / (RESULT_VIEW_SCORE_LABEL_ANIMATION_TOTAL_DURATION/RESULT_VIEW_SCORE_LABEL_ANIMATION_STEP_DURATION));
    self.activityIndicatorView.hidden = YES;
    self.products = [NumberGameIAPHelper sharedInstance].products;
    if (!self.products) {
        self.unlockButton.hidden = YES;
        self.answerImage.hidden = YES;
        self.targetAnswerLabel.hidden = YES;
    } else {
        self.answerImage.image = [UIImage imageNamed:@"UnlockAnswer.png"];
        self.answerImage.hidden = NO;
        self.targetAnswerLabel.text = [NSString stringWithFormat:@"%d",[NumberManager instance].targetAnswer];
        self.targetAnswerLabel.hidden = NO;
        self.unlockButton.hidden = NO;
    }
    
    [UIView animateWithDuration:RESULT_VIEW_VIEW_TOTAL_DURATION * 0.9f animations:^{
        self.y = -self.height * 0.05f;
    } completion:^(BOOL complete) {
        [UIView animateWithDuration:RESULT_VIEW_VIEW_TOTAL_DURATION * 0.1f animations:^{
            self.y = 0.f;
        } completion:^(BOOL complete) {
            [self performSelector:@selector(animateLabel) withObject:nil afterDelay:0.4f];
        }];
    }];
    
    [[iRate sharedInstance] logEvent:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productFailed:) name:IAPHelperProductFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAchievementEarned:) name:SHOW_ACHIEVETMENT_EARNED object:nil];
}

- (void)updateScoreLabel {
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%d", self.currentScore];
    if (self.currentScore >= self.targetScore) {
        [self.timer invalidate], self.timer = nil;
        self.currentScoreLabel.text = [NSString stringWithFormat:@"%d", self.targetScore];
        if (self.currentScore > self.lastMaxScore) {
            [self performSelector:@selector(updateMaxLabel) withObject:nil afterDelay:0.2f];
        }
        self.playButton.enabled = YES;
    } else {
        self.currentScore += self.step;
    }
}

- (void)updateMaxLabel {
    self.recordLabel.hidden = NO;
    self.maxScoreLabel.text = [NSString stringWithFormat:@"%d", self.targetScore];
    [UserData instance].maxScore = self.targetScore;
    [AnimUtil wobble:self.maxScoreLabel duration:0.2f angle:M_PI/128.f repeatCount:6.f];
    [AnimUtil wobble:self.recordLabel duration:0.2f angle:M_PI/128.f repeatCount:6.f];
}

- (void)animateLabel {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:RESULT_VIEW_SCORE_LABEL_ANIMATION_STEP_DURATION target:self selector:@selector(updateScoreLabel) userInfo:nil repeats:YES];
}

- (IBAction)socialPressed:(id)sender {
    UIButton *button = sender;
    int tag = button.tag;
    NSString *socialType = nil;
    switch (tag) {
        case 1:
            socialType = SLServiceTypeTwitter;
            break;
        case 2:
            socialType = SLServiceTypeFacebook;
            break;
        default:
            break;
    }
    if (socialType == nil) {
        return;
    }
    
    if ([SLComposeViewController isAvailableForServiceType:socialType]) {
        // Initialize Compose View Controller
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:socialType];
        // Configure Compose View Controller
        [vc setInitialText:self.sharedText];
        [vc addImage:self.sharedImage];
        // Present Compose View Controller
        [self.vc presentViewController:vc animated:YES completion:nil];
    } else {
        NSString *message = [NSString stringWithFormat:@"It seems that we cannot talk to %@ at the moment or you have not yet added your %@ account to this device. Go to the Settings application to add your %@ account to this device.", button.titleLabel.text, button.titleLabel.text, button.titleLabel.text];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)share:(id)sender {
    // Activity Items
    UIImage *image = self.sharedImage;
    NSString *caption = self.sharedText;
    NSArray *activityItems = @[image, caption];
    // Initialize Activity View Controller
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    // Present Activity View Controller
    [self.vc presentViewController:vc animated:YES completion:nil];
}

- (IBAction)unlockPressed:(id)sender {
    for (SKProduct *product in self.products) {
        if ([product.productIdentifier isEqualToString:IAP_UNLOCK_ANSWER]) {
            self.userInteractionEnabled = NO;
            NSLog(@"Buying %@...", product.productIdentifier);
            self.activityIndicatorView.hidden = NO;
            [self.activityIndicatorView startAnimating];
            [[NumberGameIAPHelper sharedInstance] buyProduct:product];
        }
    }
}

- (void)productPurchased:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    if (productIdentifier) {
        // Unlock answer
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
        self.userInteractionEnabled = YES;
        [self showAnswer];
    }
}

- (void)productFailed:(NSNotification *)notification {
    self.userInteractionEnabled = YES;
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidden = YES;
}

- (void)showAchievementEarned: (NSNotification *)notification {
    self.imgView.image = [UIImage imageNamed:notification.object];
    self.userInteractionEnabled = NO;
    [self animateAchievemnt];
}

- (void)showAnswer {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.3f animations:^{
        self.y = self.height;
    } completion:^(BOOL complete) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RESULT_VIEW_SHOW_ANSWER_NOTIFICATION object:self];
    }];
}

- (void)hide {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.3f animations:^{
        self.y = self.height;
    } completion:^(BOOL complete) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RESULT_VIEW_DISMISSED_NOTIFICATION object:self];
    }];
}

- (void)animateAchievemnt {
    self.fadeOverlay.hidden = NO;
    self.imgView.hidden = NO;
    
    // offscreen at bottom
    self.imgView.y = self.height;
    self.fadeOverlay.alpha = 0.f;
    
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
                                              self.reachedLabel.hidden = NO;
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
                                                                                        self.reachedLabel.hidden = YES;
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

                                                                                                                 }];
                                                                                    }];
                                                               }];
                                          }];
                     }];
    

}


@end

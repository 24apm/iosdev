//
//  ResultView.m
//  FlappyBall
//
//  Created by MacCoder on 2/8/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ResultView.h"
#import <Social/Social.h>
#import "AnimUtil.h"
#import "iRate.h"
#import "SoundManager.h"
#import "GameConstants.h"

@interface ResultView()

#define RESULT_VIEW_SCORE_LABEL_ANIMATION_TOTAL_DURATION 0.8f
#define RESULT_VIEW_SCORE_LABEL_ANIMATION_STEP_DURATION 0.05f
#define RESULT_VIEW_VIEW_TOTAL_DURATION 0.3f

@property NSTimer *timer;
@property int currentScore;
@property int step;
@property int targetScore;

@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;

@end

@implementation ResultView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.y = self.height;
        self.currentScore = 0;
    }
    return self;
}

- (IBAction)playAgainPressed:(id)sender {
    [self hide];
}

- (void)show {
    self.y = self.height;
    self.playButton.enabled = NO;
    self.recordLabel.hidden = YES;
    self.currentScore = 0;
    self.targetScore = [self.currentScoreLabel.text intValue];
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%d", self.currentScore];
    self.maxScoreLabel.text = [NSString stringWithFormat:@"%d", self.lastMaxScore];
    self.step = ceil((float)self.targetScore / (RESULT_VIEW_SCORE_LABEL_ANIMATION_TOTAL_DURATION/RESULT_VIEW_SCORE_LABEL_ANIMATION_STEP_DURATION));
    self.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:RESULT_VIEW_VIEW_TOTAL_DURATION * 0.9f animations:^{
        self.y = -self.height * 0.05f;
    } completion:^(BOOL complete) {
        [UIView animateWithDuration:RESULT_VIEW_VIEW_TOTAL_DURATION * 0.1f animations:^{
            self.y = 0.f;
        } completion:^(BOOL complete) {
            [self performSelector:@selector(animateLabel) withObject:nil afterDelay:0.4f];
        }];
    }];
    
    [[iRate sharedInstance] promptIfNetworkAvailable];
}

- (void)part1 {
    [[SoundManager instance] play:SOUND_EFFECT_DUN1];
    CGFloat angle = M_PI * 0.05f;
    [UIView animateWithDuration:0.1f animations:^{
        self.transform = CGAffineTransformMakeRotation(angle);
        self.transform = CGAffineTransformScale(self.transform, 1.1f, 1.1f);
    }];
}

- (void)part2 {
    [[SoundManager instance] play:SOUND_EFFECT_DUN2];
    CGFloat angle = -M_PI * 0.05f;
    [UIView animateWithDuration:0.1f animations:^{
        self.transform = CGAffineTransformMakeRotation(angle);
        self.transform = CGAffineTransformScale(self.transform, 1.15f, 1.15f);
    }];
}

- (void)part3 {
    [[SoundManager instance] play:SOUND_EFFECT_DUN3];
    CGFloat angle = M_PI * 0.10f;
    [UIView animateWithDuration:0.1f animations:^{
        self.transform = CGAffineTransformMakeRotation(angle);
        self.transform = CGAffineTransformScale(self.transform, 1.3f, 1.3f);
    }];
}

- (void)part4 {
    [[SoundManager instance] play:SOUND_EFFECT_HALLELUJAH];
    self.playButton.enabled = YES;
}

- (void)hide {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3f animations:^{
        self.y = self.height;
    } completion:^(BOOL complete) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RESULT_VIEW_DISMISSED_NOTIFICATION object:self];
    }];
}


- (void)updateScoreLabel {
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%d", self.currentScore];
    if (self.currentScore >= self.targetScore) {
        [self.timer invalidate], self.timer = nil;
        self.currentScoreLabel.text = [NSString stringWithFormat:@"%d", self.targetScore];
        if (self.maxScore > self.lastMaxScore) {
            [self performSelector:@selector(updateMaxLabel) withObject:nil afterDelay:0.2f];
        } else {
            self.playButton.enabled = YES;
        }
    } else {
        self.currentScore += self.step;
    }
}

- (void)updateMaxLabel {
    self.recordLabel.hidden = NO;
    self.maxScoreLabel.text = [NSString stringWithFormat:@"%d", self.maxScore];
    [AnimUtil wobble:self.maxScoreLabel duration:0.2f angle:M_PI/128.f repeatCount:6.f];
    [AnimUtil wobble:self.recordLabel duration:0.2f angle:M_PI/128.f repeatCount:6.f];
    [self performSelector:@selector(part1) withObject:nil afterDelay:0.6f];
    [self performSelector:@selector(part2) withObject:nil afterDelay:0.85f];
    [self performSelector:@selector(part3) withObject:nil afterDelay:1.09f];
    [self performSelector:@selector(part4) withObject:nil afterDelay:2.09f];
}

- (void)animateLabel {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:RESULT_VIEW_SCORE_LABEL_ANIMATION_STEP_DURATION target:self selector:@selector(updateScoreLabel) userInfo:nil repeats:YES];
}

- (IBAction)socialPressed:(id)sender {
    UIButton *button = sender;
    int tag = button.tag;
    NSString *socialType = nil;
    NSString *socialString = @"";
    
    switch (tag) {
        case 1:
            socialType = SLServiceTypeTwitter;
            socialString = @"Twitter";
            break;
        case 2:
            socialType = SLServiceTypeFacebook;
            socialString = @"Facebook";
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
        NSString *message = [NSString stringWithFormat:@"It seems that we cannot talk to %@ at the moment or you have not yet added your %@ account to this device. Go to the Settings application to add your %@ account to this device.", socialString, socialString, socialString];
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

@end

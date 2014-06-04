//
//  BucketView.m
//  Clicker
//
//  Created by MacCoder on 5/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BucketView.h"
#import "PromoDialogView.h"
#import "iRate.h"
#import "TrackUtils.h"
#import "GameCenterHelper.h"

#define SHOW_LEADERBOARD_NOTIFICATION @"SHOW_LEADERBOARD_NOTIFICATION"

@interface BucketView ()
@property (nonatomic) NSTimer *timer;
@end

@implementation BucketView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)rateButtonPressed:(UIButton *)sender {
    [TrackUtils trackAction:@"iRate" label:@"ratePressed"];
    [[iRate sharedInstance] promptIfNetworkAvailable];
}
- (IBAction)leaderBoard:(UIButton *)sender {
    [GameCenterHelper instance].currentLeaderBoard = kLeaderboardBestScoreID;
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_LEADERBOARD_NOTIFICATION object:self];
}

- (void)show {
    [super show];
    [self initialize];
}

- (void)initialize {
    [self imageState];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f/UPDATE_TIME_PER_TICK target:self selector:@selector(updateBar) userInfo:nil repeats:YES];
    self.percentageLabel.text = @"0";
}

- (void)imageState {
    if ([UserData instance].maxSpeedOn || [UserData instance].bucketIsFull) {
        self.bucketImage.image = [UIImage imageNamed:@"clicker_pig_full"];
    } else {
        self.bucketImage.image = [UIImage imageNamed:@"clicker_pig"];
    }
}

- (void)updateBar {
    double displayPercetage = 0;
    if (![UserData instance].maxSpeedOn && ![UserData instance].bucketIsFull) {
        double percentage = 1 - (([UserData instance].bucketFullTime - CURRENT_TIME) / [UserData instance].currentBucketWaitTime);
        displayPercetage = percentage * 100;
        [self.progressBar fillBar:percentage];
        [self imageState];
    } else {
        [self imageState];
        [self.progressBar fillBar:100.f];
        displayPercetage = 100;
    }
    self.percentageLabel.text = [NSString stringWithFormat:@"%.1f%%", displayPercetage];
}

- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:sender];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissed:self];
}

- (IBAction)bucketPressed:(id)sender {
    if ([UserData instance].bucketIsFull) {
        [[UserData instance] addOfflineScore];
        [[UserData instance] renewBucketFullTime];
        [self animateLabel:[UserData instance].offlinePoints];
    }
    
}

- (void)animateLabel:(long long)value {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self.bucketImage addSubview:label];
    label.label.text = [NSString stringWithFormat:@"+%lld", value];
    label.center = CGPointMake(self.bucketImage.bounds.size.width / 2, self.bucketImage.bounds.size.height / 2);
    [label animate];
}

@end

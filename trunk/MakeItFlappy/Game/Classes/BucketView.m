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
#import "GameLayoutView.h"
#import "Utils.h"
#import "InstructionView.h"

#define SHOW_LEADERBOARD_NOTIFICATION @"SHOW_LEADERBOARD_NOTIFICATION"

@interface BucketView ()
@property (strong, nonatomic) IBOutlet UILabel *maxHeight;
@property (strong, nonatomic) IBOutlet UILabel *maxTime;
@property (strong, nonatomic) IBOutlet UILabel *fellNumber;
@property (strong, nonatomic) IBOutlet UILabel *totalTap;
@property (strong, nonatomic) IBOutlet UILabel *lvLabel;
@property (strong, nonatomic) IBOutlet UIImageView *highestBackground;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
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
- (IBAction)instructionButtonPressed:(UIButton *)sender {
    [[[InstructionView alloc] init] show];
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
    self.maxHeight.text = [Utils formatLongLongWithShortHand:[UserData instance].maxHeight];
    self.maxTime.text = [NSString stringWithFormat:@"%.1fs",[UserData instance].maxTime];
    self.totalTap.text = [Utils formatLongLongWithShortHand:[UserData instance].totalTap];
    self.fellNumber.text = [Utils formatLongLongWithShortHand:[UserData instance].fellNumber];
    self.lvLabel.text = [NSString stringWithFormat:@"%d", [[UserData instance] currentCharacterLevel]];
    [[UserData instance] heightTierData:[UserData instance].maxHeight];
    self.highestBackground.image = [GameLayoutView backgroundImageForTier:[UserData instance].currentBackgroundTier];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideButton) name:UPGRADE_VIEW_OPEN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showButton) name:UPGRADE_VIEW_CLOSED_NOTIFICATION object:nil];
}

- (void)hideButton {
    self.closeButton.hidden = YES;
}

- (void)showButton {
    self.closeButton.hidden = NO;
}


- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:sender];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissed:self];
}

- (void)animateLabel:(long long)value {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self.bucketImage addSubview:label];
    label.label.text = [NSString stringWithFormat:@"+%lld", value];
    label.center = CGPointMake(self.bucketImage.bounds.size.width / 2, self.bucketImage.bounds.size.height / 2);
    [label animate];
}

@end
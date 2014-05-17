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
#import "UserData.h"
#import "TrackUtils.h"
#import "GameManager.h"

@implementation MainView

- (id)init {
    self = [super init];
    if (self) {
        self.resetButton.hidden = !DEBUG_MODE;
        self.resetLocalScoreButton.hidden = !DEBUG_MODE;
        self.customizeButton.hidden = YES;
        self.achievementButton.hidden = YES;
    }
    return self;
}
- (IBAction)singleModeButtonPressed:(UIButton *)sender {
    [GameManager instance].gameMode = GAME_MODE_SINGLE;
    [self hide];
}

- (IBAction)startButtonPressed:(id)sender {
    [self hide];
}

- (IBAction)timeAttackButtonPressed:(UIButton *)sender {
    [TrackUtils trackAction:@"MainMenu" label:@"PlayButtonPressed"];
    [GameManager instance].gameMode = GAME_MODE_VS;
    [self hide];
}

- (IBAction)distanceAttackButtonPressed:(UIButton *)sender {
    //[GameManager instance].gameMode = GAME_MODE_DISTANCE;
    [self hide];
}

- (IBAction)bestTimePressed:(id)sender {
    [GameCenterHelper instance].currentLeaderBoard = kLeaderboardBestTimeID;
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_LEADERBOARD_NOTIFICATION object:self];
}

- (IBAction)bestScorePressed:(id)sender {
    [GameCenterHelper instance].currentLeaderBoard = kLeaderboardBestScoreID;
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_LEADERBOARD_NOTIFICATION object:self];
}

- (IBAction)achievementPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_ACHIEVEMENT_NOTIFICATION object:self];
}

- (IBAction)resetAchievements:(id)sender {
    [[GameCenterHelper instance].gameCenterManager resetAchievements];
}

- (IBAction)demoPressed:(UIButton *)sender {
    [UserData instance].tutorialModeEnabled = YES;
    [self hide];
}

- (IBAction)resetLocalScore:(id)sender {
    [[UserData instance] resetLocalLeaderBoard];
    [[UserData instance] resetLocalScore :(NSString *)[GameManager instance].gameMode];
}

- (void)show {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
        self.alpha = 0.0f;
    } completion:^(BOOL complete) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MAIN_VIEW_DISMISSED_NOTIFICATION object:self];
    }];
}


@end

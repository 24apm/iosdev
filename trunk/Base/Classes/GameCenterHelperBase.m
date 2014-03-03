//
//  GameCenterHelp.m
//  NumberGame
//
//  Created by MacCoder on 2/27/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameCenterHelperBase.h"

@implementation GameCenterHelperBase

#pragma mark - GameCenter

- (void)loginToGameCenter {
    if ([GameCenterManager isGameCenterAvailable]) {
        
        self.gameCenterManager = [[GameCenterManager alloc] init];
        [self.gameCenterManager setDelegate:self];
        [self.gameCenterManager authenticateLocalUser];
        
    } else {
        
        // The current device does not support Game Center.
        
    }
}

#pragma mark - Leaderboard

- (void)showLeaderboard:(UIViewController *)viewController {
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL) {
        leaderboardController.category = self.currentLeaderBoard;
        leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
        leaderboardController.leaderboardDelegate = self;
        [viewController presentViewController:leaderboardController animated:YES completion:nil];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)showAchievements:(UIViewController *)viewController
{
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != NULL)
    {
        achievements.achievementDelegate = self;
        [viewController presentViewController:achievements animated:YES completion:nil];

    }
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) checkAchievements
{

}

@end

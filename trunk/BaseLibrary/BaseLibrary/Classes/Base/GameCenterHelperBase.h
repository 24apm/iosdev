//
//  GameCenterHelp.h
//  NumberGame
//
//  Created by MacCoder on 2/27/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCenterManager.h"
#import <GameKit/GameKit.h>

@interface GameCenterHelperBase : NSObject <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate>

@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;

- (void)loginToGameCenterWithAuthentication:(BOOL)showLogin;
- (void)showLeaderboard:(UIViewController *)viewController;
- (void)showLeaderboard:(UIViewController *)viewController category:(NSString *)category;
- (void)showAchievements:(UIViewController *)viewController;
- (void)checkAchievements;

// override to set scores
- (void)onLocalPlayerScoreReceived:(GKScore *)score;

@end

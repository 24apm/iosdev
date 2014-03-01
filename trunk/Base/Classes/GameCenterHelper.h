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

@interface GameCenterHelper : NSObject <GKLeaderboardViewControllerDelegate, GameCenterManagerDelegate>

@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;

+ (GameCenterHelper *)instance;
- (void)loginToGameCenter;
- (void)showLeaderboard:(UIViewController *)viewController;

@end

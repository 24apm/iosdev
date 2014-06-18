//
//  GameManager.h
//  SequenceGame
//
//  Created by MacCoder on 3/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

#define GAME_MANAGER_REFRESH_NOTIFICATION @"GAME_MANAGER_REFRESH_NOTIFICATION"
#define GAME_MANAGER_END_GAME_NOTIFICATION @"GAME_MANAGER_END_GAME_NOTIFICATION"
#define GAMEPLAY_VIEW_VICTORY_NOTIFICATION @"GAMEPLAY_VIEW_VICTORY_NOTIFICATION"

@interface GameManager : NSObject

+ (GameManager *)instance;
- (int)currentLevel;
- (int)currentLevelScore;
- (int)currentLevelMaxScore;
- (void)addScore:(int)score;
- (NSString *)scoreString;

@property (nonatomic) int score;
@property (nonatomic, strong) NSString *gameMode;

@end

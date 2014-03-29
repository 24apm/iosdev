//
//  GameManager.h
//  SequenceGame
//
//  Created by MacCoder on 3/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "MonsterData.h"
#import "GameViewController.h"

#define GAME_MANAGER_REFRESH_NOTIFICATION @"GAME_MANAGER_REFRESH_NOTIFICATION"
#define GAME_MANAGER_END_GAME_NOTIFICATION @"GAME_MANAGER_END_GAME_NOTIFICATION"
#define GAMEPLAY_VIEW_VICTORY_NOTIFICATION @"GAMEPLAY_VIEW_VICTORY_NOTIFICATION"

@interface GameManager : NSObject

- (void)generatelevelForTime;
+ (GameManager *)instance;
- (void)sequenceCaculation:(UserInput)input;
- (NSArray *)currentVisibleQueue;
- (NSString *)imagePathForUserInput:(UserInput)userInput;

@property (nonatomic, strong) NSMutableArray *unitQueue;
@property (nonatomic, strong) NSMutableArray *bossQueue;
@property (nonatomic, strong) NSString *gameMode;

@end
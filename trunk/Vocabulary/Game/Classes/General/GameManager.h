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

typedef enum {
    UserInputDefend,
    UserInputAttack
} UserInput;

typedef enum {
    Tie,
    PlayerOneWin,
    PlayerTwoWin
} Winner;

@interface GameManager : NSObject
  
+ (GameManager *)instance;
+ (NSArray *)characterImageForFlapping;
+ (NSString *)characterImageForFlying;
+ (NSString *)characterImageForFalling;
+ (NSString *)characterImageForStanding;

- (NSString *)imagePathForUserInput:(UserInput)userInput;
- (void)addScore:(UserInput)input;
- (void)resetScore;
- (Winner)calculateWinner;

@property (nonatomic, strong) NSMutableArray *unitQueue;
@property (nonatomic, strong) NSMutableArray *bossQueue;
@property (nonatomic) NSInteger step;
@property (nonatomic, strong) NSString *gameMode;

@property (nonatomic) NSInteger playerOneScore;
@property (nonatomic) NSInteger playerTwoScore;

@end

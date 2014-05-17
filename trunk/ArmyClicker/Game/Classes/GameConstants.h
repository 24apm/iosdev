//
//  GameConstants.h
//  NumberGame
//
//  Created by MacCoder on 2/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IPAD_SCALE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2.0f : 1.0f)

#define DEBUG_MODE NO
#define ENABLED_ADS YES

// Game Center
#define kLeaderboardBestTimeID @"com.jeffrwan.restroom2.fastest"
#define kLeaderboardBestScoreID @"com.jeffrwan.20485x5Blitz.point"

#define kAchievementOneStreak @"com.jeffrwan.thenumbergame.level1"
#define kAchievement5Streak @"com.jeffrwan.thenumbergame.level5"
#define kAchievement10Streak @"com.jeffrwan.thenumbergame.level10"
#define kAchievement15Streak @"com.jeffrwan.thenumbergame.level15"
#define kAchievement20Streak @"com.jeffrwan.thenumbergame.level20"
#define kAchievement30Streak @"com.jeffrwan.thenumbergame.level30"
#define kAchievement40Streak @"com.jeffrwan.thenumbergame.level40"
#define kAchievement50Streak @"com.jeffrwan.thenumbergame.level50"
#define kAchievement60Streak @"com.jeffrwan.thenumbergame.level60"
#define kAchievement75Streak @"com.jeffrwan.thenumbergame.level75"
#define kAchievement90Streak @"com.jeffrwan.thenumbergame.level90"
#define kAchievement115Streak @"com.jeffrwan.thenumbergame.level115"
#define kAchievement130Streak @"com.jeffrwan.thenumbergame.level130"
#define kAchievement150Streak @"com.jeffrwan.thenumbergame.level150"
#define kAchievement170Streak @"com.jeffrwan.thenumbergame.level170"
#define kAchievement200Streak @"com.jeffrwan.thenumbergame.level200"
#define kAchievement250Streak @"com.jeffrwan.thenumbergame.level250"
#define kAchievement350Streak @"com.jeffrwan.thenumbergame.level350"
#define kAchievement500Streak @"com.jeffrwan.thenumbergame.level500"
#define kAchievement999Streak @"com.jeffrwan.thenumbergame.level999"

// Sound effects
#define SOUND_EFFECT_POP @"pop"
#define SOUND_EFFECT_BLING @"bling"
#define SOUND_EFFECT_BOING @"boing"
#define SOUND_EFFECT_TICKING @"ticking"
#define SOUND_EFFECT_WINNING @"winningEffect"
#define SOUND_EFFECT_SHARP_PUNCH @"sharp_punch"
#define SOUND_EFFECT_BUI @"bui"
#define SOUND_EFFECT_BOILING @"boiling"
#define SOUND_EFFECT_DUING @"duing"

#define IMAGE_ARROW @"swordattack.png"
#define IMAGE_MONSTER @"soldier.png"
#define IMAGE_BOSS @"bossknight.png"

#define GAME_MODE_SINGLE @"singleMode"
#define GAME_MODE_VS @"vsMode"

#define kCOLOR_BLUE [UIColor colorWithRed:0.f/255.f green:168.f/255.f blue:255.f/255.f alpha:1.0f]
#define kCOLOR_RED [UIColor colorWithRed:208.f/255.f green:50.f/255.f blue:0.f/255.f alpha:1.0f]

#define TIMES_PLAYED_BEFORE_PROMO 3

#define UPDATE_TIME_PER_TICK 10.f
#define LEVEL_CAP 10
typedef enum {
    POWER_UP_TYPE_TAP,
    POWER_UP_TYPE_PASSIVE,
    POWER_UP_TYPE_OFFLINE
} PowerUpType;

@interface GameConstants : NSObject

@end

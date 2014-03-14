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

// Game Center
#define kLeaderboardID @"com.jeffrwan.thenumbergame.level"

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
#define SOUND_EFFECT_BOING @"whoosh"
#define SOUND_EFFECT_TICKING @"ticking"
#define SOUND_EFFECT_WINNING @"winningEffect"

#define SYMBOL_OPERATION_ADDITION @"+"
#define SYMBOL_OPERATION_SUBTRACTION @"-"
#define SYMBOL_OPERATION_MULTIPLICATION @"×"
#define SYMBOL_OPERATION_DIVSION @"÷"

@interface GameConstants : NSObject

@end

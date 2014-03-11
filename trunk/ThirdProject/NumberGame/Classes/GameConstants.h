//
//  GameConstants.h
//  NumberGame
//
//  Created by MacCoder on 2/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IPAD_SCALE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2.0f : 1.0f)

#define DEBUG_MODE YES

// Game Center
#define kLeaderboardID @"com.jeffrwan.thenumbergame.level"

#define kAchievementOneStreak @"com.jeffrwan.thenumbergame.level1"
#define kAchievement5Streak @"5_Streak"
#define kAchievement10Streak @"10_Streak"
#define kAchievement15Streak @"15_Streak"
#define kAchievement20Streak @"20_Streak"
#define kAchievement30Streak @"30_Streak"
#define kAchievement40Streak @"40_Streak"
#define kAchievement50Streak @"50_Streak"
#define kAchievement60Streak @"60_Streak"
#define kAchievement75Streak @"75_Streak"
#define kAchievement90Streak @"90_Streak"
#define kAchievement115Streak @"115_Streak"
#define kAchievement130Streak @"130_Streak"
#define kAchievement150Streak @"150_Streak"
#define kAchievement170Streak @"170_Streak"
#define kAchievement200Streak @"200_Streak"
#define kAchievement250Streak @"250_Streak"
#define kAchievement350Streak @"350_Streak"
#define kAchievement500Streak @"500_Streak"
#define kAchievement999Streak @"999_Streak"

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

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
#define kLeaderboardID @"2"

#define kAchievementOneStreak @"1_Streak"
#define kAchievement10Streak @"10_Streak"

// Sound effects
#define SOUND_EFFECT_DING @"ding"
#define SOUND_EFFECT_POP @"pop"
#define SOUND_EFFECT_BLING @"bling"
#define SOUND_EFFECT_BOING @"boing"
#define SOUND_EFFECT_TICKING @"ticking"
#define SOUND_EFFECT_WINNING @"winningEffect"

@interface GameConstants : NSObject

@end

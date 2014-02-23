//
//  GameConstants.h
//  FlappyBall
//
//  Created by MacCoder on 2/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLeaderboardID @"1"

#define IPAD_SCALE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2.0f : 1.0f)

#define GRAVITY 0.2f
#define TAP_ACCELATION_INCREASE -4.0f
#define TAP_SPEED_INCREASE -10.0f

#define OBSTACLE_SPEED_MIN -6.0f
#define OBSTACLE_SPEED_MAX -8.0f
#define OBSTACLE_SPEED_STEP 0.25f
#define OBSTACLE_SPEED_INCREASE_STEP_OVER_X_SCORES 1.f

#define OBSTACLE_GAP_BY_SCREEN_WIDTH_PERCENTAGE 0.75
#define OBSTACLE_GAP_BY_CHARACTER_MULTIPLIER_MIN 4.f
#define OBSTACLE_GAP_BY_CHARACTER_MULTIPLIER_MAX 6.f
#define OBSTACLE_GAP_BY_CHARACTER_MULTIPLIER_STEP 0.25f
#define OBSTACLE_GAP_BY_CHARACTER_MULTIPLIER_INCREASE_STEP_OVER_X_SCORES 1.f

#define PIPES_COUNT 5
#define DEBUG_MODE NO
#define BLACK_AND_WHITE_MODE YES

#define ENABLE_AD YES

#define SOUND_EFFECT_DUN1 @"dun1"
#define SOUND_EFFECT_DUN2 @"dun2"
#define SOUND_EFFECT_DUN3 @"dun3"
#define SOUND_EFFECT_BUMP @"bumpEffect"
#define SOUND_EFFECT_BOUNCE @"bounceEffect"
#define SOUND_EFFECT_BLING @"blingEffect"
#define SOUND_EFFECT_HALLELUJAH @"Hallelujah"

@interface GameConstants : NSObject

@end

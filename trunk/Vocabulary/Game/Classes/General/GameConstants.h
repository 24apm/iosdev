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
#define kLeaderboardBestScoreID @"com.jeffrwan.makeitflappy.height"

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
#define SOUND_EFFECT_GUINEA @"guinea_pig"
#define SOUND_EFFECT_ANVIL @"anvil"
#define SOUND_EFFECT_HALLELUJAH @"Hallelujah"
#define SOUND_EFFECT_CLANG @"metal_clang"

#define IMAGE_ARROW @"swordattack.png"
#define IMAGE_MONSTER @"soldier.png"
#define IMAGE_BOSS @"bossknight.png"

#define GAME_MODE_SINGLE @"singleMode"
#define GAME_MODE_VS @"vsMode"

#define kCOLOR_BLUE [UIColor colorWithRed:0.f/255.f green:168.f/255.f blue:255.f/255.f alpha:1.0f]
#define kCOLOR_RED [UIColor colorWithRed:208.f/255.f green:50.f/255.f blue:0.f/255.f alpha:1.0f]

#define TIMES_PLAYED_BEFORE_PROMO 2

#define POWER_UP_IAP_FUND @"com.jeffrwan.renthouse.fundtier1"
#define POWER_UP_IAP_DOUBLE @"com.jeffrwan.renthouse.fundtier2"
#define POWER_UP_IAP_QUADPLE @"com.jeffrwan.renthouse.fundtier3"
#define POWER_UP_IAP_SUPER @"com.jeffrwan.renthouse.fundtier4"
#define IAP_ITEM_PRESSED_NOTIFICATION @"IAP_ITEM_PRESSED_NOTIFICATION"
#define CONFIRMED_RENTER_NOTIFICATION @"CONFIRMED_RENTER_NOTIFICATION"

#define UPGRADE_ATTEMPT_NOTIFICATION @"UPGRADE_ATTEMPT_NOTIFICATION"
#define SHOP_BUTTON_PRESSED_NOTIFICATION @"SHOP_BUTTON_PRESSED_NOTIFICATION"
#define SUCCESS_UPGRADE_ANIMATION_FINISH_NOTIFICATION @"SUCCESS_UPGRADE_ANIMATION_FINISH_NOTIFICATION"
#define UPGRADE_ATTEMPT_SUCCESS_NOTIFICATION @"UPGRADE_ATTEMPT_SUCCESS_NOTIFICATION"
#define UPGRADE_ATTEMPT_FAIL_NOTIFICATION @"UPGRADE_ATTEMPT_FAIL_NOTIFICATION"
#define SHOP_VIEW_CLOSED_NOTIFICATION @"SHOP_VIEW_CLOSED_NOTIFICATION"
#define UPGRADE_VIEW_OPEN_NOTIFICATION @"UPGRADE_VIEW_OPEN_NOTIFICATION"
#define UPGRADE_VIEW_CLOSED_NOTIFICATION @"UPGRADE_VIEW_CLOSED_NOTIFICATION"

#define BUYING_PRODUCT_SUCCESSFUL_NOTIFICATION @"BUYING_PRODUCT_SUCCESSFUL_NOTIFICATION"
#define BUYING_PRODUCT_ENDED_NOTIFICATION @"BUYING_PRODUCT_ENDED_NOTIFICATION"
#define PURCHASED_HOUSE_NOTIFICATION @"PURCHASED_HOUSE_NOTIFICATION"
#define SOLD_HOUSE_NOTIFICATION @"SOLD_HOUSE_NOTIFICATION"
#define VIEWING_NEW_HOUSE_NOTIFICATION @"VIEWING_NEW_HOUSE_NOTIFICATION"
#define SHOP_TABLE_VIEW_NOTIFICATION_OPEN @"SHOP_TABLE_VIEW_NOTIFICATION_OPEN"
#define SHOP_TABLE_VIEW_NOTIFICATION_CLOSE @"SHOP_TABLE_VIEW_NOTIFICATION_CLOSE"

#define FIND_HOUSE_NOTIFICATION @"FIND_HOUSE_NOTIFICATION"

#define WAYPOINT_ITEM_PRESSED_NOTIFICATION @"WAYPOINT_ITEM_PRESSED_NOTIFICATION"
#define WAYPOINT_ITEM_ID_1 @"WAYPOINT_ITEM_ID_1"
#define WAYPOINT_ITEM_ID_2 @"WAYPOINT_ITEM_ID_2"
#define WAYPOINT_ITEM_ID_3 @"WAYPOINT_ITEM_ID_3"
#define WAYPOINT_ITEM_ID_4 @"WAYPOINT_ITEM_ID_4"
#define WAYPOINT_ITEM_ID_5 @"WAYPOINT_ITEM_ID_5"
#define WAYPOINT_ITEM_ID_6 @"WAYPOINT_ITEM_ID_6"
#define WAYPOINT_ITEM_ID_7 @"WAYPOINT_ITEM_ID_7"

#define UPDATE_TIME_PER_TICK 10.f
#define UPDATE_TIME_PER_TICK_FOR_BONUS 30.f
#define LEVEL_CAP 100
typedef enum {
    TableTypeWaypoint,
    TableTypeInventory,
    TableTypeIAP
} TableType;

typedef enum {
    BlockTypeObstacle,
    BlockTypePower,
    BlockTypeTreasure,
    BlockTypePlayer,
    BlockTypeWaypoint
} BlockType;

@interface GameConstants : NSObject

@end

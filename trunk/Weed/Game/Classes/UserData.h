//
//  UserData.h
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameConstants.h"
#import "ShopItem.h"

typedef enum {
    BackgroundTypeFlying,
    BackgroundTypeFloor,
    BackgroundTypeFloat,
    BackgroundTypeTree,
    BackgroundTypeSky,
    BackgroundTypeCloud,
    BackgroundTypeMountain,
    BackgroundTypeAtmosphere,
    BackgroundTypeSpace,
    BackgroundTypeMoon,
    BackgroundTypeVenus,
    BackgroundTypeComet,
    BackgroundTypeMercury,
    BackgroundTypeSun,
    BackgroundTypeMars,
    BackgroundTypeJupiter,
    BackgroundTypeSaturn,
    BackgroundTypeUranus,
    BackgroundTypeNepture,
    BackgroundTypePluto,
    BackgroundTypeSolar,
    BackgroundTypeGalaxy,
    BackgroundTypeOuterGalaxy,
    BackgroundTypeBlack,
    BackgroundTypeAsteroid,
    BackgroundTypeBlackEntrance,
    BackgroundTypeLast
} BackgroundType;

typedef enum {
    UpgradeTypeSpeed,
    UpgradeTypeAir,
    UpgradeTypeFlappy
} UpgradeType;

@interface UserData : NSObject

@property (nonatomic) long long currentScore;
@property (nonatomic) int currentCoin;
@property (nonatomic, strong) NSMutableDictionary *gameDataDictionary;
@property (nonatomic) int burstCost;
@property (nonatomic) int staminaCost;
@property (nonatomic) int flappyCost;
@property (nonatomic) int tapBonus;
@property (nonatomic) double startTime;
@property (nonatomic) double currentBucketWaitTime;
@property (nonatomic) long long currentMaxTapPerSecond;
@property (nonatomic) BOOL maxSpeedOn;
@property (nonatomic) long long currentMaxAir;
@property (nonatomic) long long currentAirRecovery;
@property (nonatomic) long long currentSpeed;
@property (nonatomic) long long currentAir;
@property (nonatomic) long long currentHeight;
@property (nonatomic) long long airResistence;
@property (nonatomic) BackgroundType currentBackgroundTier;
@property (nonatomic) BackgroundType prevBackgroundTier;
@property (nonatomic) BOOL sonicBoom;
@property (nonatomic) int levelBonus;
@property (nonatomic) long long maxHeight;
@property (nonatomic) double maxTime;
@property (nonatomic) int fellNumber;
@property (nonatomic) long long totalTap;

+ (UserData *)instance;
- (void)submitScore:(int)score mode:(NSString *)mode;
- (void)resetLocalScore :(NSString *)mode;
- (NSArray *)loadLocalLeaderBoard :(NSString *)mode;
- (void)addNewScoreLocalLeaderBoard:(double)newScores mode:(NSString *)mode;
- (void)resetLocalLeaderBoard;
- (void)saveUserCoin;
- (void)saveUserStartTime:(double)time;
- (void)saveGameData;
- (void)retrieveUserCoin;
- (void)levelUpPower:(ShopItem *)item;
- (long long)addScore:(BOOL)bonusOn;
- (int)totalPointPerTap:(BOOL)bonusOn;
- (float)realMultiplier:(ShopItem *)shopItem;
- (void)saveUserCurrentMaxTap:(long long)maxTap;
- (void)addCurrentHeight;
- (void)fellFromCurrentHeight:(long long)currentHeight;
- (void)heightTierData:(long long)currentHeight;
- (float)totalPowerUpFor:(PowerUpType)type UpgradeType:(NSString *)upgrade;
- (void)retrieveMaxTime;
- (void)retrieveMaxHeight;
- (void)retrieveFellNumber;
- (void)retrieveTotalTap;
- (void)savefellNumber;
- (void)saveTotalTap:(long long)tap;
- (void)saveMaxTime:(double)time;
- (void)saveMaxHeight:(long long)height;
- (int)currentCharacterLevel;
    
@end

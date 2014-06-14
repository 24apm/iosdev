//
//  UserData.h
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameConstants.h"
#import "ShopItem.h"

#define CURRENT_TIME [[NSDate date] timeIntervalSince1970]

@interface UserData : NSObject

@property (nonatomic) long long currentScore;
@property (nonatomic) int currentCoin;
@property (nonatomic, strong) NSMutableDictionary *gameDataDictionary;
@property (nonatomic) int bustCost;
@property (nonatomic) int staminaCost;
@property (nonatomic) int flappyCost;
@property (nonatomic) int tapBonus;
@property (nonatomic) double startTime;
@property (nonatomic) double currentBucketWaitTime;
@property (nonatomic) long long currentMaxTapPerSecond;
@property (nonatomic) BOOL maxSpeedOn;
@property (nonatomic) long long currentMaxAir;
@property (nonatomic) long long currentAir;

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
- (void)addScoreByTap:(BOOL)bonusOn;
- (void)addScore:(long long)score;
- (int)totalPointPerTap:(BOOL)bonusOn;
- (float)realMultiplier:(ShopItem *)shopItem;
- (void)saveUserCurrentMaxTap:(long long)maxTap;

@end

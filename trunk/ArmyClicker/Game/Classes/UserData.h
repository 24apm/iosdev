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

@property (nonatomic) float currentScore;
@property (nonatomic) int currentCoin;
@property (nonatomic, strong) NSMutableDictionary *gameDataDictionary;
@property (nonatomic) int tapBonus;
@property (nonatomic) double startTime;
@property (nonatomic) double bucketFullTime;
@property (nonatomic) BOOL bucketIsFull;
@property (nonatomic) int offlinePoints;
@property (nonatomic) double currentBucketPoints;
@property (nonatomic) double currentBucketWaitTime;
@property (nonatomic) double currentMaxTapPerSecond;
@property (nonatomic) BOOL maxSpeedOn;

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
- (void)addScoreByPassive;
- (void)updateOfflineTime;
- (void)addScore:(float)score;
- (int)totalPointPerTap:(BOOL)bonusOn;
- (float)totalPointForPassive;
- (float)totalPointForOfflineCap;
- (float)realMultiplier:(ShopItem *)shopItem;
- (void)addOfflineScore;
- (void)renewBucketFullTime;
- (void)saveUserCurrentMaxTap:(double)maxTap;

@end

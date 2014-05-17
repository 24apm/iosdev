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

@property (nonatomic, retain) UIImage *lastGameSS;
@property (nonatomic) BOOL tutorialModeEnabled;
@property (nonatomic) float currentScore;
@property (nonatomic) int currentCoin;
@property (nonatomic, strong) NSMutableDictionary *gameDataDictionary;
@property (nonatomic, strong) NSString *currentEquippedItem;
@property (nonatomic) int tapBonus;
@property (nonatomic) double logInTime;
@property (nonatomic) double startTime;

+ (UserData *)instance;
- (void)submitScore:(int)score mode:(NSString *)mode;
- (void)resetLocalScore :(NSString *)mode;
- (NSArray *)loadLocalLeaderBoard :(NSString *)mode;
- (void)addNewScoreLocalLeaderBoard:(double)newScores mode:(NSString *)mode;
- (void)resetLocalLeaderBoard;
- (void)saveUserCoin;
- (void)saveUserLogInTime:(double)time;
- (void)saveUserStartTime:(double)time;
- (void)saveGameData;
- (void)retrieveUserCoin;
- (void)levelUpPower:(ShopItem *)item;
- (void)addScoreByTap:(BOOL)bonusOn;
- (void)addScoreByPassive;
- (void)addScoreByOffline;
- (void)addScore:(float)score;
- (int)totalPointPerTap:(BOOL)bonusOn;
- (float)totalPointForPassive;

@end

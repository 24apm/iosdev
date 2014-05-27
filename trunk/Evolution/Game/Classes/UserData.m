//
//  UserData.m
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UserData.h"
#import "GameCenterHelper.h"
#import "ShopManager.h"
#import "GameConstants.h"
#import "AnimatedLabel.h"

#define NEW_USER_COIN 10

@implementation UserData

+ (UserData *)instance {
    static UserData *instance = nil;
    if (!instance) {
        instance = [[UserData alloc] init];
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] == nil) {
            //            self.currentCoin = 10;
            //            [self saveUserCoin];
        }
        [self retrieveUserCoin];
        [self restoreGameData];
        [self retrieveUserStartTime];
        [self retrieveBucketFullTime];
        self.tapBonus = 10;
    }
    return self;
}

- (void)retrieveUserCoin {
    self.currentScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] floatValue];
}

- (void)retrieveBucketFullTime {
    self.bucketFullTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bucketFullTime"] floatValue];
}

- (void)retrieveUserStartTime {
    self.startTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"] doubleValue];
    // NSLog(@"retrieveUserTime %f", self.startTime);
}

- (void)saveUserStartTime:(double)time {
    self.startTime = time;
    // NSLog(@"saveUserTime %f", self.currentTime);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithDouble:self.startTime] forKey:@"startTime"];
    [defaults synchronize];
}

- (void)saveUserBucketFullTime:(double)time {
    self.bucketFullTime = time;
    // NSLog(@"saveUserTime %f", self.currentTime);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithDouble:self.bucketFullTime] forKey:@"bucketFullTime"];
    [defaults synchronize];
}

- (void)setCurrentScore:(float)currentScore {
    _currentScore = currentScore;
}

- (void)restoreGameData {
    if(!self.gameDataDictionary) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"gameData"]) {
            self.gameDataDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"gameData"];
        } else {
            self.gameDataDictionary = [NSMutableDictionary dictionary];
            [self.gameDataDictionary setObject:[NSMutableDictionary dictionary] forKey:[NSString stringWithFormat:@"%d", POWER_UP_TYPE_TAP]];
            [self.gameDataDictionary setObject:[NSMutableDictionary dictionary] forKey:[NSString stringWithFormat:@"%d", POWER_UP_TYPE_PASSIVE]];
            [self.gameDataDictionary setObject:[NSMutableDictionary dictionary] forKey:[NSString stringWithFormat:@"%d", POWER_UP_TYPE_OFFLINE_CAP]];
            [self.gameDataDictionary setObject:[NSMutableDictionary dictionary] forKey:[NSString stringWithFormat:@"%d", POWER_UP_TYPE_OFFLINE_SPEED]];
            [self saveGameData];
        }
    }
}

- (void)saveGameData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.gameDataDictionary forKey:@"gameData"];
    [defaults synchronize];
}

- (void)saveUserCoin {
    
    if ([UserData instance].currentScore <= 0) {
        [UserData instance].currentScore = 0;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.currentScore) forKey:@"coin"];
    [defaults synchronize];
}

- (NSArray *)loadLocalLeaderBoard:(NSString *)mode {
    NSArray *localLeaderboard = [[NSUserDefaults standardUserDefaults] objectForKey:mode];
    if (!localLeaderboard) {
        localLeaderboard = [NSArray array];
    }
    return localLeaderboard;
}

- (void)saveLocalLeaderBoard:(NSArray *)array mode:(NSString *)mode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:mode];
    [defaults synchronize];
}

- (NSMutableArray *)sortingArrayDecending:(NSMutableArray *)array newNumber:(double)newNumber{
    int index = -1;
    for (int i = 0; i < array.count; i++) {
        if (newNumber > [[array objectAtIndex:i] doubleValue]) {
            index = i;
            break;
        }
    }
    if (index < 0) {
        index = array.count;
    }
    
    [array insertObject:[NSNumber numberWithDouble:newNumber] atIndex:index];
    return array;
}

- (NSMutableArray *)sortingArrayAcending:(NSMutableArray *)array newNumber:(double)newNumber{
    int index = -1;
    for (int i = 0; i < array.count; i++) {
        if (newNumber < [[array objectAtIndex:i] doubleValue]) {
            index = i;
            break;
        }
    }
    if (index < 0) {
        index = array.count;
    }
    
    [array insertObject:[NSNumber numberWithDouble:newNumber] atIndex:index];
    return array;
}

-(void)resetLocalLeaderBoard {
    NSArray *array = [NSArray array];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:GAME_MODE_SINGLE];
    //[defaults setObject:array forKey:GAME_MODE_DISTANCE];
    [defaults synchronize];
}

- (void)addNewScoreLocalLeaderBoard:(double)newScores mode:(NSString *)mode {
    // load local leaderboard
    // insert new score into leaderboard
    // sort it
    // take the top x range (truncate if neccessarily)
    // save new leaderboard
    NSMutableArray *sortedArray = sortedArray = [NSMutableArray arrayWithArray:[self loadLocalLeaderBoard :(NSString *)mode]];
    if ([mode isEqualToString:GAME_MODE_VS]) {
        sortedArray = [self sortingArrayDecending:sortedArray newNumber:newScores];
        double highestScore = [[sortedArray objectAtIndex:0] doubleValue];
        [self submitScore:highestScore mode:mode];    //gamecenter submition
    }
    NSArray *finalArray = [self truncateArray:sortedArray];
    [self saveLocalLeaderBoard:finalArray mode:(NSString *)mode];
    self.currentScore = newScores;
    // save newScores member to self.currentScore
}

- (NSArray *)truncateArray:(NSMutableArray *)array {
    NSRange range = NSMakeRange(0, MIN(array.count, 100));
    return [array subarrayWithRange:range];
}

- (void)resetLocalScore :(NSString *)mode {
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"currentLevelData"];
    [defaults synchronize];
}

- (void)submitScore:(int)score mode:(NSString *)mode {
    NSString *leaderBoardCategory = nil;
    if ([mode isEqualToString:GAME_MODE_VS]) {
        leaderBoardCategory = kLeaderboardBestScoreID;
    }
    
    if(leaderBoardCategory && score > 0) {
        [[GameCenterHelper instance].gameCenterManager reportScore:score forCategory: leaderBoardCategory];
    }
}
- (void)levelUpPower:(ShopItem *)item {
    NSMutableDictionary *typeDictionary = [self.gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", item.type]];
    NSNumber *number = [typeDictionary objectForKey:item.itemId];
    int level = 0;
    if (number != nil) {
        level = [number intValue];
    }
    if (level < LEVEL_CAP) {
        level++;
    }
    [typeDictionary setObject:[NSNumber numberWithInt:level] forKey:item.itemId];
    [self saveGameData];
}

- (float)totalPowerUpFor:(PowerUpType)type {
    float totalMultiplier = 0;
    NSMutableDictionary *typeDictionary = [self.gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", type]];
    NSArray *arrayOfId = [typeDictionary allKeys];
    for (int i = 0; i < arrayOfId.count; i++) {
        NSString *currentKey = [arrayOfId objectAtIndex:i];
        ShopItem *item =[[ShopManager instance] shopItemForItemId:currentKey dictionary:type];
        float tempMultiplier = [self realMultiplier:item];
        totalMultiplier += tempMultiplier;
    }
    
    return totalMultiplier;
}

- (float)realMultiplier:(ShopItem *)shopItem {
    NSMutableDictionary *typeDictionary = [self.gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", shopItem.type]];
    int itemLevel = [[typeDictionary objectForKey:shopItem.itemId] intValue];
    float tempMultiplier = shopItem.upgradeMultiplier * (float)itemLevel;
    return tempMultiplier;
}

- (float)totalPointForOfflineCap {
   float points = [self totalPowerUpFor:POWER_UP_TYPE_OFFLINE_CAP];
    if (points <= 0) {
        points = 1;
    }
    return points;
}

- (float)totalPointForOfflineSpeed {
    float points = 0;
    points = [self totalPowerUpFor:POWER_UP_TYPE_OFFLINE_SPEED];
    return points;
}

- (float)totalPointForPassive {
    float points = 0;
    points = [self totalPowerUpFor:POWER_UP_TYPE_PASSIVE];
    return points;
}

- (int)totalPointPerTap:(BOOL)bonusOn {
    int points = 1;
    int multiplier = (int)[self totalPowerUpFor:POWER_UP_TYPE_TAP];
    if (multiplier <= 0) {
        multiplier = 1;
    }
    
    if (!bonusOn) {
        points = 1 * multiplier;
    } else {
        points = 1 * self.tapBonus;
        points = points * multiplier;
    }
    return points;
}

- (void)addScoreByTap:(BOOL)bonusOn {
    float temp = (float)[self totalPointPerTap:bonusOn];
    self.currentScore = self.currentScore + (1.f * temp);
}

- (void)addScoreByPassive {
    self.currentScore = self.currentScore + [self totalPointForPassive]/UPDATE_TIME_PER_TICK;
}

- (void)updateOfflineTime {
    double time = CURRENT_TIME;
    if (time > self.bucketFullTime) {
        self.bucketIsFull = YES;
    } else {
        self.bucketIsFull = NO;
    }
}

- (void)addOfflineScore {
    self.offlinePoints = 100 * self.currentBucketPoints;
    self.currentScore += self.offlinePoints;
    [self saveUserCoin];
}

- (void)renewBucketFullTime {
    self.currentBucketPoints = [self totalPointForOfflineCap];
    self.bucketFullTime = CURRENT_TIME + 100 * self.currentBucketPoints;
    float speedTime = [self totalPointForOfflineSpeed];
    self.bucketFullTime -= speedTime;
    self.currentBucketWaitTime = self.bucketFullTime - CURRENT_TIME;
    if (self.currentBucketWaitTime < 10) {
        self.currentBucketWaitTime = 10;
        self.bucketFullTime = CURRENT_TIME + 10;
    }
    [self saveUserBucketFullTime:self.bucketFullTime];
    self.bucketIsFull = NO;
}

- (void)addScore:(float)score {
    self.currentScore = self.currentScore + score;
}

@end

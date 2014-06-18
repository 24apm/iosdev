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
        [self retrieveUserMaxTap];
        self.currentMaxAir = 10;
        self.tapBonus = 10;
    }
    return self;
}

- (void)retrieveUserCoin {
    self.currentScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] floatValue];
}

- (void)retrieveUserMaxTap {
    self.currentMaxTapPerSecond = [[[NSUserDefaults standardUserDefaults] objectForKey:@"maxTap"] floatValue];
}

- (void)retrieveUserStartTime {
    self.startTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"] floatValue];
}

- (void)saveUserCurrentMaxTap:(long long)maxTap {
    self.currentMaxTapPerSecond = maxTap;
    // NSLog(@"saveUserTime %f", self.currentTime);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithLongLong:self.currentMaxTapPerSecond] forKey:@"maxTap"];
    [defaults synchronize];
    [[GameCenterHelper instance].gameCenterManager reportScore:maxTap forCategory: kLeaderboardBestScoreID];
}

- (void)saveUserStartTime:(double)time {
    self.startTime = time;
    // NSLog(@"saveUserTime %f", self.currentTime);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithDouble:self.startTime] forKey:@"startTime"];
    [defaults synchronize];
}

- (void)setCurrentScore:(long long)currentScore {
    _currentScore = currentScore;
}

- (void)restoreGameData {
    if(!self.gameDataDictionary) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"gameData"]) {
            self.gameDataDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"gameData"];
        } else {
            self.gameDataDictionary = [NSMutableDictionary dictionary];
            [self.gameDataDictionary setObject:[NSMutableDictionary dictionary] forKey:[NSString stringWithFormat:@"%d", POWER_UP_TYPE_UPGRADE]];
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
    long long totalMultiplier = 0;
    NSMutableDictionary *typeDictionary = [self.gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", type]];
    NSArray *arrayOfId = [typeDictionary allKeys];
    for (int i = 0; i < arrayOfId.count; i++) {
        NSString *currentKey = [arrayOfId objectAtIndex:i];
        ShopItem *item =[[ShopManager instance] shopItemForItemId:currentKey dictionary:type];
        long long tempMultiplier = [self realMultiplier:item];
        totalMultiplier += tempMultiplier;
    }
    
    return totalMultiplier;
}

- (float)realMultiplier:(ShopItem *)shopItem {
    NSMutableDictionary *typeDictionary = [self.gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", shopItem.type]];
    int itemLevel = [[typeDictionary objectForKey:shopItem.itemId] intValue];
    long long tempMultiplier = shopItem.upgradeMultiplier * (float)itemLevel;
    return tempMultiplier;
}

- (int)totalPointPerTap:(BOOL)bonusOn {
    int points = 1;
    int multiplier = (int)[self totalPowerUpFor:POWER_UP_TYPE_UPGRADE];
    if (multiplier <= 0) {
        multiplier = 1;
    }
    
    if (!bonusOn) {
        points = multiplier;
    } else {
        points = 1 * self.tapBonus;
        points = points * multiplier;
    }
    return points;
}

- (void)addCurrentHeight {
    self.currentHeight += 1;
}

- (void)fellFromCurrentHeight {
    self.currentHeight = 0;
    [self heightTierData];
}

- (void)addScoreByTap:(BOOL)bonusOn {
    long long temp = [self totalPointPerTap:bonusOn];
    self.currentScore = self.currentScore + (temp) * self.levelBonus;
}

- (long long)addScore:(BOOL)bonusOn {
    
    long long perTapScore = 0;
    
    if (bonusOn) {
        perTapScore = self.levelBonus * 10;
        
    } else {
        perTapScore = self.levelBonus;
        
    }
    
    self.currentScore += perTapScore;
    
    return perTapScore;
}

- (void)heightTierData {
    if(self.currentHeight < 100) {
        self.airResistence = 0;
        self.currentBackgroundTier = BackgroundTypeFloat;
        self.levelBonus = 1;
        
    } else if(self.currentHeight < 200) {
        self.airResistence = 1;
        self.currentBackgroundTier = BackgroundTypeTree;
        self.levelBonus = 2;
        
    } else if(self.currentHeight < 500) {
        self.airResistence = 2;
        self.currentBackgroundTier = BackgroundTypeSky;
        self.levelBonus = 5;
        
    } else if(self.currentHeight < 1000) {
        self.airResistence = 3;
        self.currentBackgroundTier = BackgroundTypeCloud;
        self.levelBonus = 10;
        
    } else if(self.currentHeight < 2000) {
        self.airResistence = 8;
        self.currentBackgroundTier = BackgroundTypeMountain;
        self.levelBonus = 50;
        
    } else if(self.currentHeight < 5000) {
        self.airResistence = 15;
        self.currentBackgroundTier = BackgroundTypeAtmosphere;
        self.levelBonus = 100;
        
    } else if(self.currentHeight < 10000) {
        self.airResistence = 30;
        self.currentBackgroundTier = BackgroundTypeSpace;
        self.levelBonus = 400;
        
    } else if(self.currentHeight < 30000) {
        self.airResistence = 70;
        self.currentBackgroundTier = BackgroundTypeMoon;
        self.levelBonus = 1000;
        
    } else if(self.currentHeight < 50000) {
        self.airResistence = 100;
        self.currentBackgroundTier = BackgroundTypeVenus;
        self.levelBonus = 3000;
        
    } else if(self.currentHeight < 100000) {
        self.airResistence = 300;
        self.currentBackgroundTier = BackgroundTypeComet;
        self.levelBonus = 8000;
        
    } else if(self.currentHeight < 500000) {
        self.airResistence = 800;
        self.currentBackgroundTier = BackgroundTypeMercury;
        self.levelBonus = 30000;
        
    } else if(self.currentHeight < 1000000) {
        self.airResistence = 1700;
        self.currentBackgroundTier = BackgroundTypeSun;
        self.levelBonus = 500000;
        
    } else if(self.currentHeight < 10000000) {
        self.airResistence = 3000;
        self.currentBackgroundTier = BackgroundTypeMars;
        self.levelBonus = 1;
        
    } else if(self.currentHeight < 100000000) {
        self.airResistence = 8000;
        self.currentBackgroundTier = BackgroundTypeJupiter;
        self.levelBonus = 1;
        
    } else if(self.currentHeight < 100000000000) {
        self.airResistence = 100000;
        self.currentBackgroundTier = BackgroundTypeSaturn;
        self.levelBonus = 1;
        
    } else if(self.currentHeight < 99999999999999){
        self.airResistence = 10000000;
        self.currentBackgroundTier = BackgroundTypeUranus;
        self.levelBonus = 1;
        
    } else if(self.currentHeight < 99999999999999){
        self.airResistence = 10000000;
        self.currentBackgroundTier = BackgroundTypeNepture;
        self.levelBonus = 1;
        
    } else if(self.currentHeight < 99999999999999){
        self.airResistence = 10000000;
        self.currentBackgroundTier = BackgroundTypePluto;
        self.levelBonus = 1;
        
    } else if(self.currentHeight < 99999999999999){
        self.airResistence = 10000000;
        self.currentBackgroundTier = BackgroundTypeSolar;
        self.levelBonus = 1;
        
    } else if(self.currentHeight < 99999999999999){
        self.airResistence = 10000000;
        self.currentBackgroundTier = BackgroundTypeGalaxy;
        self.levelBonus = 1;
        
    }
}

@end

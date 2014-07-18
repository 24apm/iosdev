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
#import "TrackUtils.h"

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
        self.sonicBoom = NO;
        [self retrieveUserCoin];
        [self restoreGameData];
        [self retrieveUserMaxTap];
        self.currentMaxAir = 10;
        self.tapBonus = 10;
        self.currentAirRecovery = 1;
        self.currentSpeed = 1;
        [self retrieveFellNumber];
        [self retrieveMaxHeight];
        [self retrieveMaxTime];
        [self retrieveTotalTap];
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

- (void)retrieveMaxTime {
    self.maxTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"maxTime"] floatValue];
}

- (void)retrieveMaxHeight {
    self.maxHeight = [[[NSUserDefaults standardUserDefaults] objectForKey:@"maxHeight"] floatValue];
}

- (void)retrieveFellNumber {
    self.fellNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"fellNumber"] floatValue];
}

- (void)retrieveTotalTap {
    self.totalTap = [[[NSUserDefaults standardUserDefaults] objectForKey:@"totalTap"] floatValue];
}

- (void)saveUserCurrentMaxTap:(long long)maxTap {
    self.currentMaxTapPerSecond = maxTap;
    // NSLog(@"saveUserTime %f", self.currentTime);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithLongLong:self.currentMaxTapPerSecond] forKey:@"maxTap"];
    [defaults synchronize];
}

- (void)saveUserStartTime:(double)time {
    self.startTime = time;
    // NSLog(@"saveUserTime %f", self.currentTime);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithDouble:self.startTime] forKey:@"startTime"];
    [defaults synchronize];
}

- (void)saveMaxHeight:(long long)height {
    if (self.maxHeight < height) {
        self.maxHeight = height;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithLongLong:self.maxHeight] forKey:@"maxHeight"];
        [defaults synchronize];
        [[GameCenterHelper instance].gameCenterManager reportScore:height forCategory: kLeaderboardBestScoreID];
    }
}

- (void)saveMaxTime:(double)time {
    if (self.maxTime < time) {
        self.maxTime = time;
        // NSLog(@"saveUserTime %f", self.currentTime);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithDouble:self.maxTime] forKey:@"maxTime"];
        [defaults synchronize];
    }
}

- (void)savefellNumber {
    self.fellNumber++;
    // NSLog(@"saveUserTime %f", self.currentTime);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:self.fellNumber] forKey:@"fellNumber"];
    [defaults synchronize];
}

- (void)saveTotalTap:(long long)tap {
    self.totalTap += tap;
    // NSLog(@"saveUserTime %f", self.currentTime);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithLongLong:self.totalTap] forKey:@"totalTap"];
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
            [self resetStats];
        }
    }
}

- (void)resetStats {
    self.gameDataDictionary = [NSMutableDictionary dictionary];
    [self.gameDataDictionary setObject:[NSMutableDictionary dictionary] forKey:[NSString stringWithFormat:@"%d", POWER_UP_TYPE_UPGRADE]];
    
    NSMutableDictionary *typeDictionary = [self.gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", POWER_UP_TYPE_UPGRADE]];
    [typeDictionary setObject:[NSNumber numberWithInt:1] forKey:SHOP_ITEM_ID_UPGRADE_SPEED];
    [typeDictionary setObject:[NSNumber numberWithInt:0] forKey:SHOP_ITEM_ID_UPGRADE_FLAPPY];
    [typeDictionary setObject:[NSNumber numberWithInt:0] forKey:SHOP_ITEM_ID_UPGRADE_AIR];
    [self saveGameData];
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

- (float)totalPowerUpFor:(PowerUpType)type UpgradeType:(NSString *)upgrade {
    long double totalMultiplier = 0;
    NSMutableDictionary *typeDictionary = [self.gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", type]];
    NSString *currentKey = @"default";
    
    
    NSNumber *value = [typeDictionary objectForKey:upgrade];
    if (value) {
        currentKey = upgrade;
    }
    
    ShopItem *item =[[ShopManager instance] shopItemForItemId:currentKey dictionary:type];
    totalMultiplier = [self realMultiplier:item];
    if (totalMultiplier <= 0) {
        totalMultiplier = 1;
    }
    return totalMultiplier;
}

- (float)realMultiplier:(ShopItem *)shopItem {
    NSMutableDictionary *typeDictionary = [self.gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", shopItem.type]];
    int itemLevel = [[typeDictionary objectForKey:shopItem.itemId] intValue];
    return shopItem.upgradeMultiplier * (float)itemLevel;
}

- (int)totalPointPerTap:(BOOL)bonusOn {
    int points = 1;
    
    if (bonusOn) {
        points = 1 * self.tapBonus;
    }
    return points;
}

- (void)addCurrentHeight {
    self.currentHeight += 1;
}

- (void)fellFromCurrentHeight:(long long)currentHeight {
    [self heightTierData:currentHeight];
    [[GameCenterHelper instance].gameCenterManager reportScore:currentHeight forCategory: kLeaderboardBestScoreID];
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

- (void)heightTierData:(long long)currentHeight {
    self.currentHeight = currentHeight;
    if(self.currentHeight < 300) {
        self.airResistence = 2;
        self.currentBackgroundTier = BackgroundTypeFloor;
        self.levelBonus = 1;
        
    } else if(self.currentHeight < 4000) {
        self.airResistence = 3;
        self.currentBackgroundTier = BackgroundTypeGrass;
        self.levelBonus = 2;
        
    } else if(self.currentHeight < 8000) {
        self.airResistence = 15;
        self.currentBackgroundTier = BackgroundTypeGrassFoot;
        self.levelBonus = 3;
        
    }
    else if(self.currentHeight < 12000) {
        self.airResistence = 25;
        self.currentBackgroundTier = BackgroundTypeGrassLeg;
        self.levelBonus = 4;
        
    }
    else if(self.currentHeight < 18000) {
        self.airResistence = 30;
        self.currentBackgroundTier = BackgroundTypeGrassBody;
        self.levelBonus = 5;
        
    }
    else if(self.currentHeight < 30000) {
        self.airResistence = 35;
        self.currentBackgroundTier = BackgroundTypeGrassHead;
        self.levelBonus = 6;
        
    }
    else if(self.currentHeight < 50000) {
        self.airResistence = 40;
        self.currentBackgroundTier = BackgroundTypeFloat;
        self.levelBonus = 7;
        
    }
    else if(self.currentHeight < 80000) {
        self.airResistence = 50;
        self.currentBackgroundTier = BackgroundTypeTree;
        self.levelBonus = 10;
        
    }
    else if(self.currentHeight < 100000) {
        self.airResistence = 80;
        self.currentBackgroundTier = BackgroundTypeSky;
        self.levelBonus = 15;
        
    } else if(self.currentHeight < 300000) {
        self.airResistence = 90;
        self.currentBackgroundTier = BackgroundTypeCloud;
        self.levelBonus = 30;
        
    } else if(self.currentHeight < 600000) {
        self.airResistence = 100;
        self.currentBackgroundTier = BackgroundTypeMountain;
        self.levelBonus = 50;
        
    } else if(self.currentHeight < 700000) {
        self.airResistence = 140;
        self.currentBackgroundTier = BackgroundTypeAtmosphere;
        self.levelBonus = 100;
        
    } else if(self.currentHeight < 850000) {
        self.airResistence = 145;
        self.currentBackgroundTier = BackgroundTypeSpace;
        self.levelBonus = 120;
        
    } else if(self.currentHeight < 100000) {
        self.airResistence = 150;
        self.currentBackgroundTier = BackgroundTypeMoon;
        self.levelBonus = 150;
        
    } else if(self.currentHeight < 1100000) {
        self.airResistence = 160;
        self.currentBackgroundTier = BackgroundTypeVenus;
        self.levelBonus = 200;
        
    } else if(self.currentHeight < 1500000) {
        self.airResistence = 170;
        self.currentBackgroundTier = BackgroundTypeMercury;
        self.levelBonus = 250;
        
    } else if(self.currentHeight < 1600000) {
        self.airResistence = 200;
        self.currentBackgroundTier = BackgroundTypeSun;
        self.levelBonus = 400;
        
    } else if(self.currentHeight < 1700000) {
        self.airResistence = 220;
        self.currentBackgroundTier = BackgroundTypeComet;
        self.levelBonus = 450;
        
    } else if(self.currentHeight < 1900000) {
        self.airResistence = 240;
        self.currentBackgroundTier = BackgroundTypeMars;
        self.levelBonus = 500;
        
    } else if(self.currentHeight < 2000000) {
        self.airResistence = 280;
        self.currentBackgroundTier = BackgroundTypeAsteroid;
        self.levelBonus = 550;
        
    } else if(self.currentHeight < 2200000) {
        self.airResistence = 320;
        self.currentBackgroundTier = BackgroundTypeJupiter;
        self.levelBonus = 600;
        
    } else if(self.currentHeight < 2400000) {
        self.airResistence = 340;
        self.currentBackgroundTier = BackgroundTypeSaturn;
        self.levelBonus = 650;
        
    } else if(self.currentHeight < 2600000){
        self.airResistence = 360;
        self.currentBackgroundTier = BackgroundTypeUranus;
        self.levelBonus = 700;
        
    } else if(self.currentHeight < 3000000){
        self.airResistence = 370;
        self.currentBackgroundTier = BackgroundTypeNepture;
        self.levelBonus = 750;
        
    } else if(self.currentHeight < 3500000){
        self.airResistence = 380;
        self.currentBackgroundTier = BackgroundTypePluto;
        self.levelBonus = 800;
        
    } else if(self.currentHeight < 5000000){
        self.airResistence = 400;
        self.currentBackgroundTier = BackgroundTypeSolar;
        self.levelBonus = 1000;
        
    } else if(self.currentHeight < 8000000){
        self.airResistence = 450;
        self.currentBackgroundTier = BackgroundTypeGalaxy;
        self.levelBonus = 2000;
        
    } else if(self.currentHeight < 15000000) {
        self.airResistence = 500;
        self.currentBackgroundTier = BackgroundTypeOuterGalaxy;
        self.levelBonus = 4000;
        
    } else if(self.currentHeight < 23000000) {
        self.airResistence = 600;
        self.currentBackgroundTier = BackgroundTypeBlack;
        self.levelBonus = 6000;
        
    } else if(self.currentHeight < 30000000) {
        self.airResistence = 700;
        self.currentBackgroundTier = BackgroundTypeBlackEntrance;
        self.levelBonus = 8000;
        
    } else {
        self.airResistence = 800;
        self.currentBackgroundTier = BackgroundTypeLast;
        self.levelBonus = 0;
    }
    [self checkSonicBoom];
}

- (int)currentCharacterLevel {
    NSMutableDictionary *typeDictionary = [self.gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", POWER_UP_TYPE_UPGRADE]];
    return [[typeDictionary objectForKey:SHOP_ITEM_ID_UPGRADE_FLAPPY]intValue] + [[typeDictionary objectForKey:SHOP_ITEM_ID_UPGRADE_SPEED]intValue] + [[typeDictionary objectForKey:SHOP_ITEM_ID_UPGRADE_AIR]intValue];
}

- (NSString *)windLevelCheck {
    NSString *windLevel = SOUND_EFFECT_FORESTWIND;
    if (self.currentBackgroundTier > BackgroundTypeTree) {
        windLevel = SOUND_EFFECT_WINDY;
    }
    return windLevel;
}

- (void)checkSonicBoom {
    if (self.currentBackgroundTier != self.prevBackgroundTier) {
        self.prevBackgroundTier = self.currentBackgroundTier;
        self.sonicBoom = YES;
    [TrackUtils trackAction:[NSString stringWithFormat:@"Background Level %d",self.prevBackgroundTier] label:@"End"];
    } else {
        self.sonicBoom = NO;
    }
}
@end

//
//  UserData.m
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UserData.h"
#import "GameCenterHelper.h"
#import "GameConstants.h"
#import "GameConstants.h"

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
    }
    return self;
}

- (void)retrieveUserCoin {
    //self.currentCoin = 1000;
    self.currentCoin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] intValue];
}

- (void)saveUserCoin {
    
    if ([UserData instance].currentCoin <= 0) {
        [UserData instance].currentCoin = 0;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.currentCoin) forKey:@"coin"];
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

@end

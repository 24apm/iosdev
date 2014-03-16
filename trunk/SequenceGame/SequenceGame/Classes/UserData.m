//
//  UserData.m
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UserData.h"
#import "GameCenterHelper.h"

@implementation UserData

+ (UserData *)instance {
    static UserData *instance = nil;
    if (!instance) {
        instance = [[UserData alloc] init];
        instance.maxScore = [[[NSUserDefaults standardUserDefaults] valueForKey:@"maxScore"] intValue];
    }
    return instance;
}

- (NSArray *)loadLocalLeaderBoard {
    NSArray *localLeaderboard = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrayOfScores"];
    if (!localLeaderboard) {
        localLeaderboard = [NSArray array];
    }
    return localLeaderboard;
}

- (void)saveLocalLeaderBoard:(NSArray *)array {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:@"arrayOfScores"];
    [defaults synchronize];
}

- (NSMutableArray *)sortingArray:(NSMutableArray *)array :(double)newNumber{
    int index = 0;
    for (int i = 0; i < array.count; i++) {
        if (newNumber < [[array objectAtIndex:i] doubleValue]) {
            index = i;
            break;
        } else {
            index = array.count;
        }
    }
    [array insertObject:[NSNumber numberWithDouble:newNumber] atIndex:index];
    return array;
}

-(void)resetLocalLeaderBoard {
    NSArray *array = [NSArray array];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:@"arrayOfScores"];
    [defaults synchronize];
}

- (void)addNewScoreLocalLeaderBoard:(double)newScores {
    // load local leaderboard
    // insert new score into leaderboard
    // sort it
    // take the top x range (truncate if neccessarily)
    // save new leaderboard
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:[self loadLocalLeaderBoard]];
    sortedArray = [self sortingArray:sortedArray :newScores];
    NSArray *finalArray = [self truncateArray:sortedArray];
    [self saveLocalLeaderBoard:finalArray];
    self.currentScore = newScores;
    // save newScores member to self.currentScore
}

- (NSArray *)truncateArray:(NSMutableArray *)array {
    NSRange range = NSMakeRange(0, MIN(array.count,10));
    return [array subarrayWithRange:range];
}

- (void)setScore:(int)score {
    _score = score;
}

- (void)setMaxScore:(int)maxScore {
    if (maxScore > _maxScore) {
        _maxScore = maxScore;
        [self saveUserScore:_maxScore];
    }
}

- (void)saveUserScore:(int)score {
    [self submitScore:score];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:@(score) forKey:@"maxScore"];
    [defaults synchronize];
}

- (void)resetLocalScore {
    [self saveUserScore:0];
    _maxScore = 0;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"currentLevelData"];
    [defaults synchronize];
}

- (void)submitScore:(int)score {
    if(score > 0) {
        [[GameCenterHelper instance].gameCenterManager reportScore:score forCategory: [GameCenterHelper instance].currentLeaderBoard];
    }
}

@end

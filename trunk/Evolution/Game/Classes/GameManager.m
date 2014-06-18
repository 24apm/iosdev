//
//  GameManager.m
//  SequenceGame
//
//  Created by MacCoder on 3/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameManager.h"
#import "GameConstants.h"

@interface GameManager()

@property (nonatomic, retain) NSArray *levelMap;

@end

@implementation GameManager

+ (GameManager *)instance {
    static GameManager *instance = nil;
    if (!instance) {
        instance = [[GameManager alloc] init];
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.levelMap = [self levelMap];
    }
    return self;
}

- (int)currentLevel {
    for (int i = 0; i < self.levelMap.count; i++) {
        if (self.score < [(NSNumber *)self.levelMap[i] intValue]) {
            return i+1;
        }
    }
    return (int)self.levelMap.count;
}

- (NSArray *)levelMap {
    return @[@20,
             @40,
             @80,
             @160,
             @320,
             @620,
             @1220,
             @1520];
}

- (int)currentLevelScore {
    int score = self.score;
    int currentLevel = [self currentLevel];
    if (currentLevel > 1) {
        int previousMaxScore = [(NSNumber *)self.levelMap[currentLevel - 2] intValue];
        score -= previousMaxScore;
    }
    return score;
}

- (int)currentLevelMaxScore {
    int currentLevel = [self currentLevel];
    int maxScore;
    if (currentLevel > 1) {
        maxScore = [(NSNumber *)self.levelMap[currentLevel - 1] intValue] - [(NSNumber *)self.levelMap[currentLevel - 2] intValue];
    } else {
        maxScore = [(NSNumber *)self.levelMap[0] intValue];
    }
    return maxScore;
}

- (void)addScore:(int)score {
    self.score += score;
}

- (NSString *)scoreString {
    return [NSString stringWithFormat:@"%d/%d", self.currentLevelScore, self.currentLevelMaxScore];
}

@end

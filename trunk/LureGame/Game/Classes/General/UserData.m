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
#import "NSArray+Util.h"
#import "TrackUtils.h"
#import "CoinIAPHelper.h"
#import "CoinView.h"


#define NEW_USER_COIN 0
#define DEFAULT_STAMINA_LEVEL 1

NSString *const UserDataHouseDataChangedNotification = @"UserDataHouseDataChangedNotification";

@interface UserData()

@end

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
        [self setup];
    }
    return self;
}

- (void)setup {
    // Stamina Capacity Level
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"retryCapacity"] == nil) {
        self.retryCapacity = 5;
        [self saveData:@(self.retryCapacity) forKey:@"retryCapacity"];
    } else {
        self.retryCapacity = [[[NSUserDefaults standardUserDefaults] objectForKey:@"retryCapacity"] integerValue];
    }
    
    // Current Level
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentLevel"] == nil) {
        self.currentLevel = 1;
        [self saveData:@(self.currentLevel) forKey:@"currentLevel"];
    } else {
        self.currentLevel = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLevel"] integerValue];
    }
    
    // Stamina Capacity Level
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"retry"] == nil) {
        self.retry = self.retryCapacity;
        [self saveData:@(self.retry) forKey:@"retry"];
    } else {
        self.retry = [[[NSUserDefaults standardUserDefaults] objectForKey:@"retry"] integerValue];
    }
    
    // Coin
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] == nil) {
        self.coin = NEW_USER_COIN;
        [self saveData:@(self.coin) forKey:@"coin"];
    } else {
        self.coin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] integerValue];
    }
    
    // Pokedex
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pokedex"] == nil) {
        self.pokedex = [NSMutableArray array];
        [self saveData:self.pokedex forKey:@"pokedex"];
    } else {
        self.pokedex = [[NSUserDefaults standardUserDefaults] objectForKey:@"pokedex"];
    }
    
    // Unseen words
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"unseenWords"] == nil) {
        self.unseenWords = [NSMutableDictionary dictionary];
        [self saveData:self.unseenWords forKey:@"unseenWords"];
    } else {
        self.unseenWords = [[NSUserDefaults standardUserDefaults] objectForKey:@"unseenWords"];
    }
    //  Retry Time
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"retrytime"] == nil) {
        self.retryTime = 0;
        [self saveData:[NSNumber numberWithDouble:self.retryTime] forKey:@"retrytime"];
    } else {
        self.retryTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"retrytime"] doubleValue];
    }
    
    // Game played
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"gamePlayed"] == nil) {
        self.gamePlayed = 0;
        [self saveData:@(self.gamePlayed) forKey:@"gamePlayed"];
    } else {
        self.gamePlayed = [[[NSUserDefaults standardUserDefaults] objectForKey:@"gamePlayed"] integerValue];
    }
}

- (void)retryRefillStartAt:(double)time {
    self.retryTime = time;
    [self saveData:[NSNumber numberWithDouble:self.retryTime] forKey:@"retrytime"];
}

- (void)addUnseenWord:(NSString *)word {
    [self.unseenWords setValue:word forKey:word];
    [self saveData:self.unseenWords forKey:@"unseenWords"];
}

- (void)removeUnseenWord:(NSString *)word {
    [self.unseenWords removeObjectForKey:word];
    [self saveData:self.unseenWords forKey:@"unseenWords"];
}

- (NSInteger)unseenWordCount {
    return self.unseenWords.count;
}

- (void)updateDictionaryWith:(NSString *)newVocabulary {
    if (![self hasVocabFound:newVocabulary]) {
        NSMutableArray *unsortedArray = self.pokedex;
        [unsortedArray addObject:newVocabulary];
        NSArray *sortedArray = [unsortedArray sortedArrayUsingSelector:@selector(compare:)];
        self.pokedex = [NSMutableArray arrayWithArray:sortedArray];

        [self saveData:self.pokedex forKey:@"pokedex"];
    }
}

- (void)incrementGamePlayed {
    self.gamePlayed++;
    [TrackUtils trackAction:@"gamePlayed" label:[NSString stringWithFormat:@"%ld", (long)self.gamePlayed]];
    [self saveData:@(self.gamePlayed) forKey:@"gamePlayed"];
}

- (BOOL)hasVocabFound:(NSString *)newVocabulary  {
    if ([self.pokedex containsObject:newVocabulary]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)refillRetry {
   self.retry = self.retryCapacity;
    [self saveData:@(self.retry) forKey:@"retry"];
}

- (void)refillRetryByOne {
    self.retry++;
    if (self.retry > self.retryCapacity) {
        self.retry = self.retryCapacity;
    }
    [self saveData:@(self.retry) forKey:@"retry"];
}

- (void)decrementRetry {
    self.retry--;
    if (self.retry < 0) {
        self.retry = 0;
    }
    [self saveData:@(self.retry) forKey:@"retry"];
}

- (BOOL)hasRetry {
    return self.retry > 0;
}

- (BOOL)hasCoin:(long long)coin {
    return self.coin >= coin;
}

- (void)incrementCoin:(long long)coin {
    if (self.coin <= 0) {
        self.coin = 0;
    }
    
    self.coin += coin;
    
    [self saveData:@(self.coin) forKey:@"coin"];
}

- (void)incrementCurrentLevel {
    
    self.currentLevel++;
    
    [self saveData:@(self.currentLevel) forKey:@"currentLevel"];
}

- (void)decrementCoin:(long long)coin {
    self.coin -= coin;
    if (self.coin <= 0) {
        self.coin = 0;
    }

    [self saveData:@(self.coin) forKey:@"coin"];
}

- (void)saveData:(NSObject *)obj forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

- (void)resetUserDefaults {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [self setup];
}

- (BOOL)isTutorial {
    return self.pokedex.count < 1;
}
@end

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


#define NEW_USER_COIN 1000
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
        self.retryCapacity = 3;
        [self saveData:@(self.retryCapacity) forKey:@"retryCapacity"];
    } else {
        self.retryCapacity = [[[NSUserDefaults standardUserDefaults] objectForKey:@"retryCapacity"] integerValue];
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
}


- (void)updateDictionaryWith:(NSString *)newVocabulary {
    NSMutableArray *unsortedArray = self.pokedex;
    if (![unsortedArray containsObject:newVocabulary]) {
        [unsortedArray addObject:newVocabulary];
        NSArray *sortedArray = [unsortedArray sortedArrayUsingSelector:@selector(compare:)];
        self.pokedex = [NSMutableArray arrayWithArray:sortedArray];
        [self saveData:self.pokedex forKey:@"pokedex"];
    }
}

- (void)refillRetry {
    self.retry = self.retryCapacity;
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

- (void)decrementCoin:(long long)coin {
    if (self.coin <= 0) {
        self.coin = 0;
    }
    
    self.coin -= coin;
    
    [self saveData:@(self.coin) forKey:@"coin"];
}

- (void)saveData:(NSObject *)obj forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

@end

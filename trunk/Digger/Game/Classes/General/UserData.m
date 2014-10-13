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
#import "AnimatedLabel.h"
#import "NSArray+Util.h"
#import "TrackUtils.h"
#import "CoinIAPHelper.h"
#import "CoinView.h"
#import "LevelManager.h"

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
    
    // Knapsack
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"knapsack"] == nil) {
        self.knapsack = [NSMutableArray array];
        [self saveData:self.knapsack forKey:@"knapsack"];
    } else {
        self.knapsack = [[NSUserDefaults standardUserDefaults] objectForKey:@"knapsack"];
    }
    
    // Knapsack Capacity Level
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"knapsackCapacity"] == nil) {
        self.knapsackCapacity = 2;
        [self saveData:@(self.knapsackCapacity) forKey:@"knapsackCapacity"];
    } else {
        self.knapsackCapacity = [[[NSUserDefaults standardUserDefaults] objectForKey:@"knapsackCapacity"] integerValue];
    }
    
    // Coin
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] == nil) {
        self.coin = NEW_USER_COIN;
        [self saveData:@(self.coin) forKey:@"coin"];
    } else {
        self.coin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] integerValue];
    }
    
    // Retry Capacity
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"retry"] == nil) {
        self.retry = self.retryCapacity;
        [self saveData:@(self.retry) forKey:@"retry"];
    } else {
        self.retry = [[[NSUserDefaults standardUserDefaults] objectForKey:@"retry"] integerValue];
    }
    
    // Stamina Capacity Level
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"staminaCapacityLevel"] == nil) {
        self.staminaCapacityLevel = DEFAULT_STAMINA_LEVEL;
        [self saveData:@(self.staminaCapacityLevel) forKey:@"staminaCapacityLevel"];
    } else {
        self.staminaCapacityLevel = [[[NSUserDefaults standardUserDefaults] objectForKey:@"staminaCapacityLevel"] integerValue];
    }
    
    // Stamina
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"stamina"] == nil) {
        [self refillStamina];
    } else {
        self.stamina = [[[NSUserDefaults standardUserDefaults] objectForKey:@"stamina"] integerValue];
    }
    
    // Drill Level
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"drillLevel"] == nil) {
        self.drillLevel = 1;
        [self saveData:@(self.drillLevel) forKey:@"drillLevel"];
    } else {
        self.drillLevel = [[[NSUserDefaults standardUserDefaults] objectForKey:@"drillLevel"] integerValue];
    }
    // Waypoint Level
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"waypointLevel"] == nil) {
        self.waypointRank = [NSMutableArray array];
        [self.waypointRank addObject:[NSNumber numberWithInt:0]];
        [self saveData:self.waypointRank forKey:@"waypointLevel"];
    } else {
        self.waypointRank = [[NSUserDefaults standardUserDefaults] objectForKey:@"waypointLevel"];
    }
}

- (void)unlockWaypointRank:(NSUInteger)integer {
    NSNumber *newNumber = [NSNumber numberWithInt:integer];
    if (![self.waypointRank containsObject:newNumber]) {
        [self.waypointRank addObject:newNumber];
    }
    
    [self saveData:self.waypointRank forKey:@"waypointLevel"];
}

- (void)incrementLevelDrill {
    self.drillLevel++;;
    
    [self saveData:@(self.drillLevel) forKey:@"drillLevel"];
}

- (void)incrementLevelStaminaCapacity {
    self.staminaCapacityLevel++;;
    
    [self saveData:@(self.staminaCapacityLevel) forKey:@"staminaCapacityLevel"];
}

- (void)incrementKnapsackCapacity {
    self.knapsackCapacity++;;
    
    [self saveData:@(self.staminaCapacityLevel) forKey:@"knapsackCapacity"];
}

- (void)addKnapsackWith:(Treasure)treasureTier {
        [self.knapsack addObject:[NSNumber numberWithInteger:treasureTier]];
        
        [self saveData:self.knapsack forKey:@"knapsack"];
}

- (void)removeKnapsackIndex:(NSUInteger)treasureIndex {
    [self.knapsack removeObjectAtIndex:treasureIndex];
    
    [self saveData:self.knapsack forKey:@"knapsack"];
}

- (long long)staminaCapacity {
    return [[LevelManager instance] staminaCapacityForLevel:self.staminaCapacityLevel];
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

- (void)incrementStamina:(long long)stamina {
    self.stamina += stamina;
    
    if (self.stamina > self.staminaCapacity) {
        self.stamina = self.staminaCapacity;
    }
    
    [self saveData:@(self.stamina) forKey:@"stamina"];
}

- (void)decrementStamina:(long long)stamina {
    self.stamina -= stamina;
    
    if (self.stamina <= 0) {
        self.stamina = 0;
    }
    
    [self saveData:@(self.stamina) forKey:@"stamina"];
}

- (void)refillStamina {
    self.stamina = self.staminaCapacity;
    [self saveData:@(self.stamina) forKey:@"stamina"];
}

- (float)formatPercentageStamina {
    return (float)self.stamina / (float)self.staminaCapacity;
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

- (void)incrementDepth:(NSUInteger)depth {
    self.currentDepth += depth;
}

- (void)resetDepth {
    self.currentDepth = 0;
}

- (BOOL)isKnapsackFull {
    BOOL full = NO;
    if (self.knapsack.count >= self.knapsackCapacity) {
        full = YES;
    }
    return full;
}

- (BOOL)isKnapsackOverWeight {
    BOOL overweight = NO;
    NSUInteger overMax = self.knapsackCapacity + 1;
    if (self.knapsack.count >= overMax) {
        overweight = YES;
    }
    return overweight;
}

- (void)saveData:(NSObject *)obj forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

@end

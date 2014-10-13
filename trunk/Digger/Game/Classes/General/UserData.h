//
//  UserData.h
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameConstants.h"


extern NSString *const UserDataHouseDataChangedNotification;

@interface UserData : NSObject

+ (UserData *)instance;

- (void)decrementRetry;
- (void)refillRetry;
- (BOOL)hasRetry;

- (BOOL)hasCoin:(long long)coin;
- (void)incrementCoin:(long long)coin;
- (void)decrementCoin:(long long)coin;

- (void)incrementStamina:(long long)stamina;
- (void)decrementStamina:(long long)stamina;
- (void)incrementLevelStaminaCapacity;
- (float)formatPercentageStamina;
- (void)refillStamina;

- (void)incrementLevelDrill;

- (void)unlockWaypointRank:(NSUInteger)integer;

- (void)incrementDepth:(NSUInteger)depth;
- (void)resetDepth;

- (void)addKnapsackWith:(Treasure)treasure;
- (void)removeKnapsackIndex:(NSUInteger)treasure;
- (void)incrementKnapsackCapacity;
- (BOOL)isKnapsackFull;
- (BOOL)isKnapsackOverWeight;

@property (nonatomic) NSInteger retry;
@property (nonatomic) NSInteger retryCapacity;

@property (nonatomic) long long coin;
@property (nonatomic) long long stamina;
@property (nonatomic) long long staminaCapacity;
@property (nonatomic) long long staminaCapacityLevel;
@property (nonatomic) long long drillLevel;
@property (nonatomic) NSUInteger currentDepth;
@property (strong, nonatomic) NSMutableArray *waypointRank;

@property (strong, nonatomic) NSMutableArray *knapsack;
@property (nonatomic) NSUInteger knapsackCapacity;

@end

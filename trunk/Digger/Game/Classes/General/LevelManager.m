//
//  LevelManager.m
//  Weed
//
//  Created by MacCoder on 7/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "LevelManager.h"
#import "Utils.h"
#import "UserData.h"
#import "GameConstants.h"

@interface LevelManager()

@end

@implementation LevelManager

+ (LevelManager *)instance {
    static LevelManager *instance = nil;
    if (!instance) {
        instance = [[LevelManager alloc] init];
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
    
}

- (NSArray *)levelDataTypeFor:(NSUInteger)slots {
    
    NSMutableArray *levelDataType = [NSMutableArray array];
    
    for (int i = 0; i < slots; i++) {
        [levelDataType addObject:[NSNumber numberWithInteger:BlockTypeObstacle]];
    }
    
    return [self addGoods:levelDataType];
}

- (NSMutableArray *)addGoods:(NSMutableArray *)leveData {
    
    NSMutableArray *leveDataWithGoods = leveData;
    
    NSUInteger numOfPower = [Utils randBetweenMinInt:0 max:2];
    NSUInteger numOfTreasure = [Utils randBetweenMinInt:0 max:3];
    NSUInteger numOfGoods = [Utils randBetweenMinInt:1 max:5];
    NSUInteger numOfPowerMade = 0;
    NSUInteger numOfTreasureMade = 0;
    NSUInteger numOfGoodsMade = 0;
    
    for (int i = 0; i < numOfGoods; i++) {
        BlockType block = [Utils randBetweenMinInt:BlockTypePower max:BlockTypeTreasure];
        if (block == BlockTypePower && numOfPowerMade <= numOfPower) {
            numOfPowerMade++;
        } else if (block == BlockTypeTreasure && numOfTreasureMade <= numOfTreasure) {
            numOfTreasureMade++;
        }
        [leveDataWithGoods replaceObjectAtIndex:[Utils randBetweenMinInt:0 max:leveDataWithGoods.count - 1] withObject:[NSNumber numberWithInteger:block]];
    }
    
    return leveDataWithGoods;
}

- (NSArray *)levelDataTierFor:(NSUInteger)slots {
    NSMutableArray *levelDataTier = [NSMutableArray array];
    for (int i = 0; i < slots; i++) {
        [levelDataTier addObject:[NSNumber numberWithInt:[Utils randBetweenMinInt:1 max:9]]];
    }
    return levelDataTier;
}

- (BOOL)purchaseStaminaUpgrade {
    long long cost = [self staminaUpgradeCostForLevel:[UserData instance].staminaCapacityLevel + 1];
    if ([[UserData instance] hasCoin:cost]) {
        [[UserData instance] incrementLevelStaminaCapacity];
        [[UserData instance] decrementCoin:cost];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)purchaseDrillUpgrade {
    long long cost = [self drillUpgradeCostForLevel:[UserData instance].drillLevel + 1];
    if ([[UserData instance] hasCoin:cost]) {
        [[UserData instance] incrementLevelDrill];
        [[UserData instance] decrementCoin:cost];
        return YES;
    } else {
        return NO;
    }
}

- (long long)drillUpgradeCostForLevel:(long long)level {
    // lvl 1 = 9
    // lvl 2 = 16
    // lvl 3 = 25
    // lvl 4 = 36
    return ((level + 2) * (level + 2));
}

- (long long)drillPowerForLevel:(long long)level {
    // lvl 1 = 1
    // lvl 2 = 2
    // lvl 3 = 3
    // lvl 4 = 4 ...
    return level;
}

- (long long)staminaUpgradeCostForLevel:(long long)level {
    // lvl 1 = 5
    // lvl 2 = 10
    // lvl 3 = 15
    // lvl 4 = 20
    return 5 + (level - 1) * 5;
}

- (long long)staminaCapacityForLevel:(long long)level {
    // lvl 1 = 10
    // lvl 2 = 12
    // lvl 3 = 14
    // lvl 4 = 16 ...
    return 10 + (level - 1) * 2;
}

@end

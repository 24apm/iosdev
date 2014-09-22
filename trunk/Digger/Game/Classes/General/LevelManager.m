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
        [levelDataTier addObject:[NSNumber numberWithInt:[Utils randBetweenMinInt:1 max:3]]];
    }
    return levelDataTier;
}
@end

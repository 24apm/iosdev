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
#import "BoardManager.h"
#import "TableManager.h"

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

//- (NSArray *)levelDataTypeFor:(NSUInteger)slots {
//
//    NSMutableArray *levelDataType = [NSMutableArray array];
//
//    for (int i = 0; i < slots; i++) {
//        [levelDataType addObject:[NSNumber numberWithInteger:BlockTypeObstacle]];
//    }
//
//    return [self addGoods:levelDataType];
//}

//- (NSArray *)levelDataTierFor:(NSUInteger)slots {
//    NSMutableArray *levelDataTier = [NSMutableArray array];
//    NSUInteger depth = [[BoardManager instance] checkCurrentDepth]/ NUM_ROW;
//    NSUInteger max = [self maxForDepth:depth];
//    NSUInteger min = [self minForDepth:depth];
//    for (int i = 0; i < slots; i++) {
//        [levelDataTier addObject:[NSNumber numberWithInt:[Utils randBetweenMinInt:min max:max]]];
//    }
//    return levelDataTier;
//}

- (NSArray *)levelDataTypeAndTierFor:(NSUInteger)slots {
    NSMutableArray *levelData = [NSMutableArray array];
    NSMutableArray *levelDataType = [NSMutableArray array];
    NSMutableArray *levelDataTier = [NSMutableArray array];
    NSMutableArray *levelDataBlockTier = [NSMutableArray array];
    
    NSArray *waypointID = [[TableManager instance] arrayOfitemIdsFor:TableTypeWaypoint];
    NSUInteger waypointIndex = [self calculateWaypointLevel:waypointID];
    WaypointRowItem *waypointItem = [[TableManager instance] waypointItemForItemId:[waypointID objectAtIndex:waypointIndex] dictionary:TableTypeWaypoint];
    NSUInteger buffer = 2 + NUM_ROW;
    BOOL spawnWaypoint = NO;
    if ([UserData instance].currentDepth > (waypointItem.level - buffer)) {
        spawnWaypoint = YES;
    }
    
    for (int i = 0; i < slots; i++) {
        [levelDataType addObject:[NSNumber numberWithInteger:BlockTypeObstacle]];
        [levelDataTier addObject:[NSNumber numberWithInt:[self randomNumberBasedOnDepth]]];
        [levelDataBlockTier addObject:[NSNumber numberWithInt:[self randomNumberBasedOnDepth]]];
    }
    
    [levelData addObject:levelDataType];
    [levelData addObject:levelDataTier];
    
    [self addGoods:levelData];
    
    if (spawnWaypoint) {
        levelData = [self addWaypoint:levelData atPosition:waypointItem.level withRank:waypointItem.rank];
    }
    
    // [self addDesignLine:levelData];
    //[self addDesignCross:levelData];
    //  [self addDesignBoxRight:levelData];
    //    [self addDesignBoxLeft:levelData];
    [levelData addObject:levelDataBlockTier];
    return levelData;
}

- (NSUInteger)randomNumberBasedOnDepth {
    NSUInteger depthLevel = [UserData instance].currentDepth/ NUM_ROW;
    NSUInteger max = [self maxForDepth:depthLevel];
    NSUInteger min = [self minForDepth:depthLevel];
    return [Utils randBetweenMinInt:min max:max];
}

- (NSMutableArray *)addGoods:(NSMutableArray *)levelData {
    
    NSMutableArray *levelDataTypeWithGoodsType = [levelData objectAtIndex:0];
    NSMutableArray *levelDataTypeWithGoodsTier = [levelData objectAtIndex:1];
    
    NSUInteger numOfPower = [Utils randBetweenMinInt:5 max:10];
    NSUInteger numOfTreasure = [Utils randBetweenMinInt:5 max:10];
    NSUInteger numOfGoods = [Utils randBetweenMinInt:5 max:10];
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
        NSUInteger target = [Utils randBetweenMinInt:0 max:levelDataTypeWithGoodsType.count - 1];
        [levelDataTypeWithGoodsType replaceObjectAtIndex:target withObject:[NSNumber numberWithInteger:block]];
        [levelDataTypeWithGoodsTier replaceObjectAtIndex:target withObject:[NSNumber numberWithInteger:[self randomNumberBasedOnDepth]]];
    }
    NSMutableArray *levelDataTypeWithGoods = [NSMutableArray array];
    [levelDataTypeWithGoods addObject:levelDataTypeWithGoodsType];
    [levelDataTypeWithGoods addObject:levelDataTypeWithGoodsTier];
    
    return levelDataTypeWithGoods;
}

- (NSUInteger)calculateWaypointLevel:(NSArray *)waypointID {
    NSUInteger waypointIndex = 0;
    NSUInteger currentDepth = [UserData instance].currentDepth;
    
    for (int i = 0; i < waypointID.count; i++) {
        WaypointRowItem *waypointItem = [[TableManager instance] waypointItemForItemId:[waypointID objectAtIndex:i] dictionary:TableTypeWaypoint];
        NSUInteger checkWaypoint = waypointItem.level;
        if (currentDepth < checkWaypoint) {
            waypointIndex = i;
            break;
        }
    }
    return waypointIndex;
}

- (NSMutableArray *)addWaypoint:(NSMutableArray *)levelData atPosition:(NSUInteger)position withRank:(NSUInteger)rank{
    NSMutableArray *levelDataWithDesign = [NSMutableArray array];
    NSMutableArray *levelDataTypeWithDesign = [levelData objectAtIndex:LevelDataType];
    NSMutableArray *levelDataTierWithDesign = [levelData objectAtIndex:LevelDataTier];
    NSUInteger gap = position % [UserData instance].currentDepth;
    NSUInteger targetPosition = [Utils randBetweenMinInt:0 max:NUM_COL - 1];
    gap *= NUM_COL;
    targetPosition += gap;
    
    [levelDataTierWithDesign replaceObjectAtIndex:targetPosition withObject:[NSNumber numberWithInt:rank]];
    
    [levelDataTypeWithDesign replaceObjectAtIndex:targetPosition withObject:[NSNumber numberWithInteger:BlockTypeWaypoint]];
    
    [levelDataWithDesign addObject:levelDataTypeWithDesign];
    [levelDataWithDesign addObject:levelDataTierWithDesign];
    
    return levelDataWithDesign;
}

- (NSMutableArray *)addDesignCross:(NSMutableArray *)levelData {
    
    NSMutableArray *levelDataWithDesign = [NSMutableArray array];
    NSMutableArray *levelDataTypeWithDesign = [levelData objectAtIndex:LevelDataType];
    NSMutableArray *levelDataTierWithDesign = [levelData objectAtIndex:LevelDataTier];
    
    NSUInteger bonus = 7;//[Utils randBetweenMinInt:3 max:5];
    NSUInteger bonusLevel = [self randomNumberBasedOnDepth] + bonus;
    BlockType blockTreasure = [Utils randBetweenMinInt:BlockTypePower max:BlockTypeTreasure];
    BlockType blockObstacle = BlockTypeObstacle;
    
    NSUInteger target = [Utils randBetweenMinInt:NUM_COL max:levelDataTierWithDesign.count - 1];
    [levelDataTierWithDesign replaceObjectAtIndex:target withObject:[NSNumber numberWithInt:bonusLevel]];
    
    
    [levelDataTypeWithDesign replaceObjectAtIndex:target withObject:[NSNumber numberWithInteger:blockTreasure]];
    
    if (target % NUM_COL != 0) {
        NSUInteger newTarget = target - 1;
        [levelDataTypeWithDesign replaceObjectAtIndex:newTarget withObject:[NSNumber numberWithInteger:blockObstacle]];
        [levelDataTierWithDesign replaceObjectAtIndex:newTarget withObject:[NSNumber numberWithInt:bonusLevel]];
    }
    if ((target +1) % (NUM_COL) != 0) {
        NSUInteger newTarget = target + 1;
        [levelDataTypeWithDesign replaceObjectAtIndex:newTarget withObject:[NSNumber numberWithInteger:blockObstacle]];
        [levelDataTierWithDesign replaceObjectAtIndex:newTarget withObject:[NSNumber numberWithInt:bonusLevel]];
    }
    if (target >= NUM_COL) {
        NSUInteger newTarget = target - NUM_COL;
        [levelDataTypeWithDesign replaceObjectAtIndex:newTarget withObject:[NSNumber numberWithInteger:blockObstacle]];
        [levelDataTierWithDesign replaceObjectAtIndex:newTarget withObject:[NSNumber numberWithInt:bonusLevel]];
    }
    if (target < (levelDataTypeWithDesign.count - NUM_COL)) {
        NSUInteger newTarget = target + NUM_COL;
        [levelDataTypeWithDesign replaceObjectAtIndex:newTarget withObject:[NSNumber numberWithInteger:blockObstacle]];
        [levelDataTierWithDesign replaceObjectAtIndex:newTarget withObject:[NSNumber numberWithInt:bonusLevel]];
    }
    
    [levelDataWithDesign addObject:levelDataTypeWithDesign];
    [levelDataWithDesign addObject:levelDataTierWithDesign];
    
    return levelDataWithDesign;
}

- (BlockType)randomTreasure {
    return [Utils randBetweenMinInt:BlockTypePower max:BlockTypeTreasure];
}

- (NSMutableArray *)addDesignBoxLeft:(NSMutableArray *)levelData {
    
    NSMutableArray *levelDataWithDesign = [NSMutableArray array];
    NSMutableArray *levelDataTypeWithDesign = [levelData objectAtIndex:LevelDataType];
    NSMutableArray *levelDataTierWithDesign = [levelData objectAtIndex:LevelDataTier];
    
    NSUInteger bonus = 10;//[Utils randBetweenMinInt:3 max:5];
    NSUInteger bonusLevel = [self randomNumberBasedOnDepth] + bonus;
    
    BlockType blockObstacle = BlockTypeObstacle;
    
    NSUInteger target = [Utils randBetweenMinInt:2 max:NUM_ROW-3];
    target *= NUM_COL;
    
    [levelDataTierWithDesign replaceObjectAtIndex:target withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+1 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+1 withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+2 withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+2 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-NUM_COL  withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-NUM_COL withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-NUM_COL+1 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-NUM_COL+1 withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-NUM_COL+2 withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-NUM_COL+2 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+NUM_COL+1 withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+NUM_COL+1 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+NUM_COL+2 withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+NUM_COL+2 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+NUM_COL withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+NUM_COL withObject:[NSNumber numberWithInt:bonusLevel]];
    
    
    [levelDataTypeWithDesign replaceObjectAtIndex:target-(NUM_COL*2) withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-(NUM_COL*2) withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-(NUM_COL*2)+1 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-(NUM_COL*2)+1 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-(NUM_COL*2)+2 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-(NUM_COL*2)+2 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-(NUM_COL*2)+3 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-(NUM_COL*2)+3 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-NUM_COL+3 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-NUM_COL+3 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+3 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+3 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+NUM_COL+3 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+NUM_COL+3 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+(NUM_COL*2)+3 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+(NUM_COL*2)+3 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+(NUM_COL*2)+2 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+(NUM_COL*2)+2 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+(NUM_COL*2)+1 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+(NUM_COL*2)+1 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+(NUM_COL*2) withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+(NUM_COL*2) withObject:[NSNumber numberWithInt:bonusLevel]];
    
    [levelDataWithDesign addObject:levelDataTypeWithDesign];
    [levelDataWithDesign addObject:levelDataTierWithDesign];
    
    return levelDataWithDesign;
}

- (NSMutableArray *)addDesignBoxRight:(NSMutableArray *)levelData {
    
    NSMutableArray *levelDataWithDesign = [NSMutableArray array];
    NSMutableArray *levelDataTypeWithDesign = [levelData objectAtIndex:LevelDataType];
    NSMutableArray *levelDataTierWithDesign = [levelData objectAtIndex:LevelDataTier];
    
    NSUInteger bonus = 10;//[Utils randBetweenMinInt:3 max:5];
    NSUInteger bonusLevel = [self randomNumberBasedOnDepth] + bonus;
    
    BlockType blockObstacle = BlockTypeObstacle;
    
    NSUInteger target = [Utils randBetweenMinInt:2 max:NUM_ROW-3];
    target *= NUM_COL;
    target = target + NUM_COL -1;
    
    [levelDataTierWithDesign replaceObjectAtIndex:target withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-1 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-1 withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-2 withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-2 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-NUM_COL  withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-NUM_COL withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-NUM_COL-1 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-NUM_COL-1 withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-NUM_COL-2 withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-NUM_COL-2 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+NUM_COL-1 withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+NUM_COL-1 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+NUM_COL-2 withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+NUM_COL-2 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+NUM_COL withObject:[NSNumber numberWithInteger:[self randomTreasure]]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+NUM_COL withObject:[NSNumber numberWithInt:bonusLevel]];
    
    
    [levelDataTypeWithDesign replaceObjectAtIndex:target-(NUM_COL*2) withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-(NUM_COL*2) withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-(NUM_COL*2)-1 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-(NUM_COL*2)-1 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-(NUM_COL*2)-2 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-(NUM_COL*2)-2 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-(NUM_COL*2)-3 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-(NUM_COL*2)-3 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-NUM_COL-3 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-NUM_COL-3 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target-3 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target-3 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+NUM_COL-3 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+NUM_COL-3 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+(NUM_COL*2)-3 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+(NUM_COL*2)-3 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+(NUM_COL*2)-2 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+(NUM_COL*2)-2 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+(NUM_COL*2)-1 withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+(NUM_COL*2)-1 withObject:[NSNumber numberWithInt:bonusLevel]];
    [levelDataTypeWithDesign replaceObjectAtIndex:target+(NUM_COL*2) withObject:[NSNumber numberWithInteger:blockObstacle]];
    [levelDataTierWithDesign replaceObjectAtIndex:target+(NUM_COL*2) withObject:[NSNumber numberWithInt:bonusLevel]];
    
    [levelDataWithDesign addObject:levelDataTypeWithDesign];
    [levelDataWithDesign addObject:levelDataTierWithDesign];
    
    return levelDataWithDesign;
}

- (NSMutableArray *)addDesignLine:(NSMutableArray *)levelData {
    
    NSMutableArray *levelDataWithDesign = [NSMutableArray array];
    NSMutableArray *levelDataTypeWithDesign = [levelData objectAtIndex:LevelDataType];
    NSMutableArray *levelDataTierWithDesign = [levelData objectAtIndex:LevelDataTier];
    
    NSUInteger bonus = 4;//[Utils randBetweenMinInt:3 max:5];
    NSUInteger bonusLevel = [self randomNumberBasedOnDepth] + bonus;
    BlockType blockObstacle = BlockTypeObstacle;
    
    NSUInteger target = [Utils randBetweenMinInt:0 max:NUM_ROW-1];
    target *=NUM_COL;
    NSUInteger newTargetStart = target;
    
    NSUInteger breakPoint = [Utils randBetweenMinInt:0 max:NUM_COL-1];
    for (int i = 0; i < NUM_COL; i++) {
        NSUInteger newTarget = newTargetStart + i;
        if (i != breakPoint) {
            [levelDataTypeWithDesign replaceObjectAtIndex:newTarget withObject:[NSNumber numberWithInteger:blockObstacle]];
            [levelDataTierWithDesign replaceObjectAtIndex:newTarget withObject:[NSNumber numberWithInt:bonusLevel]];
        }
    }
    
    [levelDataWithDesign addObject:levelDataTypeWithDesign];
    [levelDataWithDesign addObject:levelDataTierWithDesign];
    
    return levelDataWithDesign;
}


- (NSUInteger)minForDepth:(NSUInteger)depthLevel {
    NSUInteger min = 1;
    if (depthLevel >= 10) {
        min = 1;
    } else if(depthLevel >= 4) {
        min = 2;
    }
    return min;
}

- (NSUInteger)maxForDepth:(NSUInteger)depthLevel {
    NSUInteger max = 1;
    if (depthLevel >= 10) {
        max = 2;
    } else if(depthLevel >= 4) {
        max = 3;
    }
    return max;
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

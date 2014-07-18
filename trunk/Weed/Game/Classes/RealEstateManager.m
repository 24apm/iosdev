//
//  RealEstateManager.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RealEstateManager.h"
#import "UserData.h"
#import "Utils.h"

@implementation RealEstateManager

+ (RealEstateManager *)instance {
    static RealEstateManager *instance = nil;
    if (!instance) {
        instance = [[RealEstateManager alloc] init];
    }
    return instance;
}

- (BOOL)canPurchaseHouse:(HouseData *)data {
    return [UserData instance].coin >= data.cost && [UserData instance].houses.count < 20;
}

- (BOOL)purchaseHouse:(HouseData *)data {
    if ([self canPurchaseHouse:data]) {
        [[UserData instance] decrementCoin:data.cost];
        [[UserData instance] addHouse:data];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)canSellHouse:(HouseData *)data {
    return [UserData instance].houses.count > 1;
}

- (void)sellHouse:(HouseData *)data buyerPrice:(double)buyerPrice {
    [[UserData instance] incrementCoin:buyerPrice];
    [[UserData instance] removeHouse:data];
}

- (void)collectMoney:(HouseData *)data {
    data.renterData.timeDue = CURRENT_TIME + data.renterData.duration;
    [[UserData instance] incrementCoin:data.renterData.cost];
    [[UserData instance] saveHouse];
}

- (BOOL)canAddRenter:(HouseData *)data {
    if ([RealEstateManager instance].currentRenterData) {
        return [RealEstateManager instance].currentRenterData.renterData.count <= data.unitSize;
    }
    return NO;
}

- (BOOL)addRenter:(HouseData *)data {
    if ([self canAddRenter:data]) {
        data.renterData = [RealEstateManager instance].currentRenterData.renterData;
        data.renterData.timeDue = CURRENT_TIME + data.renterData.duration;
        [RealEstateManager instance].currentRenterData = nil;
        [[UserData instance] saveHouse];
        return YES;
    } else {
        return NO;
    }
}

- (void)removeRenter:(HouseData *)data {
    data.renterData = nil;
    [[UserData instance] saveHouse];
}

- (NSString *)imageForHouseUnitSize:(int)unitSize {
    return [NSString stringWithFormat:@"House%d.png",CLAMP(unitSize / 3, 1, 3)];
}

- (int)userMaxHouseSize {
    NSArray *houses = [UserData instance].houses;
    int max = 0;
    for (HouseData *house in houses) {
        if (house.unitSize > max) {
            max = house.unitSize;
        }
    }
    return max;
}

@end

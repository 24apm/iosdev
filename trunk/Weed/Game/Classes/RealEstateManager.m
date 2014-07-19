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
    return [self canPurchaseHouseWithHouseLimit:data] && [self canPurchaseHouseWithMoney:data];
}

- (BOOL)canPurchaseHouseWithMoney:(HouseData *)data {
    return [UserData instance].coin >= data.cost;
}

- (BOOL)canPurchaseHouseWithHouseLimit:(HouseData *)data {
    return [UserData instance].houses.count < 10;
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

- (BOOL)canCollectMoney:(HouseData *)data {
    return CURRENT_TIME > data.renterData.timeDue;
}

- (BOOL)collectMoney:(HouseData *)data {
    if ([self canCollectMoney:data]) {
        data.renterData.timeDue = CURRENT_TIME + data.renterData.duration;
        [[UserData instance] incrementCoin:data.renterData.cost];
        [[UserData instance] saveHouse];
        return YES;
    } else {
        return NO;
    }
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
    return [NSString stringWithFormat:@"House%d.png",CLAMP((int)ceil((float)unitSize / 3.f), 1, 3)];
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

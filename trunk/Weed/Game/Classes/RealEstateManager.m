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
    return [UserData instance].coin >= data.cost;
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

- (void)sellHouse:(HouseData *)data {
    [[UserData instance] incrementCoin:data.cost];
    [[UserData instance] removeHouse:data];
}

- (void)collectMoney:(HouseData *)data {
    data.renterData.timeDue = CURRENT_TIME + data.renterData.duration;
    [[UserData instance] incrementCoin:data.renterData.cost];
    [[UserData instance] saveHouse];
}

@end

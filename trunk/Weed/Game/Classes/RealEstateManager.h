//
//  RealEstateManager.h
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealEstateVisitorData.h"
#import "RenterVisitorData.h"
#import "HouseData.h"

typedef enum {
    RealEstateManagerStateNormal,
    RealEstateManagerStateEdit
} RealEstateManagerState;

@interface RealEstateManager : NSObject

+ (RealEstateManager *)instance;

- (BOOL)canPurchaseHouse:(HouseData *)data;
- (BOOL)purchaseHouse:(HouseData *)data;

- (BOOL)canSellHouse:(HouseData *)data;
- (void)sellHouse:(HouseData *)data;

- (void)collectMoney:(HouseData *)data;

- (void)addRenter:(HouseData *)data;
- (void)removeRenter:(HouseData *)data;

@property (nonatomic) RealEstateManagerState state;
@property (strong, nonatomic) RenterVisitorData *currentRenterData;

@end

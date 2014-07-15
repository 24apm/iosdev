//
//  RealEstateManager.h
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealEstateVisitorData.h"
#import "HouseData.h"

@interface RealEstateManager : NSObject

+ (RealEstateManager *)instance;

- (BOOL)canPurchaseHouse:(HouseData *)data;
- (BOOL)purchaseHouse:(HouseData *)data;

- (BOOL)canSellHouse:(HouseData *)data;
- (void)sellHouse:(HouseData *)data;

- (void)collectMoney:(HouseData *)data;

@end

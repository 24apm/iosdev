//
//  ShopItems.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopItem.h"
#import "GameConstants.h"

#define SHOP_ITEM_ID_ACTIVE_TIER_1 @"SHOP_ITEM_ID_ACTIVE_TIER_1"
#define SHOP_ITEM_ID_ACTIVE_TIER_2 @"SHOP_ITEM_ID_ACTIVE_TIER_2"
#define SHOP_ITEM_ID_PASSIVE_TIER_1 @"SHOP_ITEM_ID_PASSIVE_TIER_1"
#define SHOP_ITEM_ID_OFFLINE_TIER_1 @"SHOP_ITEM_ID_OFFLINE_TIER_1"

@interface ShopManager : NSObject

+ (ShopManager *)instance;
- (NSArray *)arrayOfitemIdsFor:(PowerUpType)type;
- (int) priceForItemId:(NSString *)itemId type:(PowerUpType)type;
- (ShopItem *)shopItemForItemId:(NSString *)itemId dictionary:(PowerUpType)type;

@end

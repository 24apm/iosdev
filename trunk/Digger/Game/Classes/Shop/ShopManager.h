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

#define SHOP_ITEM_ID_IAD_FUND2 @"SHOP_ITEM_ID_IAP_2"
#define SHOP_ITEM_ID_IAD_FUND3 @"SHOP_ITEM_ID_IAP_3"
#define SHOP_ITEM_ID_IAD_FUND4 @"SHOP_ITEM_ID_IAP_4"
#define SHOP_ITEM_ID_IAP_FUND @"SHOP_ITEM_ID_IAP_1"
@interface ShopManager : NSObject

+ (ShopManager *)instance;
- (NSArray *)arrayOfitemIdsFor:(PowerUpType)type;
- (long long) priceForItemId:(NSString *)itemId type:(PowerUpType)type;
- (ShopItem *)shopItemForItemId:(NSString *)itemId dictionary:(PowerUpType)type;

@end

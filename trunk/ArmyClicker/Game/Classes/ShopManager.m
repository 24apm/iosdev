//
//  ShopItems.m
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ShopManager.h"
#import "UserData.h"

@interface ShopManager()

@property (nonatomic, strong) NSMutableDictionary *itemsForTap;
@property (nonatomic, strong) NSMutableDictionary *itemsForPassive;
@property (nonatomic, strong) NSMutableDictionary *itemsForOffline;

@end

@implementation ShopManager

+ (ShopManager *)instance {
    static ShopManager *instance = nil;
    if (!instance) {
        instance = [[ShopManager alloc] init];
        [instance setupItems];
    }
    return instance;
}

- (NSMutableDictionary *)tapItems {
    return self.itemsForTap;
}

- (NSMutableDictionary *)passiveItems {
    return self.itemsForPassive;
}

- (NSMutableDictionary *)offlineItems {
    return self.itemsForOffline;
}
- (void)setupItems {
    self.itemsForTap = [NSMutableDictionary dictionary];
    self.itemsForPassive = [NSMutableDictionary dictionary];
    self.itemsForOffline = [NSMutableDictionary dictionary];
    
    ShopItem *item = [[ShopItem alloc] init];
    [item setupName:@"Passive Level UP"
        description:@"Increase Points Per Second!"
          imagePath:@"tier1"
             itemId:SHOP_ITEM_ID_PASSIVE_TIER_1];
    item.priceMultiplier = 10;
    item.upgradeMultiplier = 0.3f;
    item.type = POWER_UP_TYPE_PASSIVE;
    [self.itemsForPassive setObject:item forKey:SHOP_ITEM_ID_PASSIVE_TIER_1];
    
    ShopItem *item2 = [[ShopItem alloc] init];
    [item2 setupName:@"Tap Level UP"
         description:@"Increase Points Per Tap!"
           imagePath:@"tier2"
              itemId:SHOP_ITEM_ID_ACTIVE_TIER_1];
    item2.priceMultiplier = 20;
    item2.upgradeMultiplier = 2.f;
    item2.type = POWER_UP_TYPE_TAP;
    [self.itemsForTap setObject:item2 forKey:SHOP_ITEM_ID_ACTIVE_TIER_1];
    
    ShopItem *item3 = [[ShopItem alloc] init];
    [item3 setupName:@"SOMETHING Level UP"
         description:@"Increase Points Per SOMETHING!"
           imagePath:@"tier3"
              itemId:SHOP_ITEM_ID_OFFLINE_TIER_1];
    item3.priceMultiplier = 100;
    item3.upgradeMultiplier = 1.f;
    item3.type = POWER_UP_TYPE_OFFLINE;
    [self.itemsForOffline setObject:item3 forKey:SHOP_ITEM_ID_OFFLINE_TIER_1];
}

- (int)priceForItemId:(NSString *)itemId type:(PowerUpType)type {
    NSMutableDictionary *tempDictionary = [self dictionaryForType:type];
    ShopItem *shopItem = [tempDictionary objectForKey:itemId];
    NSDictionary *userTypeDictionary = [[UserData instance].gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", type]];
    int lvl = [[userTypeDictionary objectForKey:itemId] integerValue] + 1;
    
    int price = shopItem.priceMultiplier * lvl;
    return price;
}

- (NSMutableDictionary *)dictionaryForType:(PowerUpType)type {
    switch (type) {
        case POWER_UP_TYPE_TAP:
            return self.itemsForTap;
            break;
        case POWER_UP_TYPE_PASSIVE:
            return self.itemsForPassive;
            break;
        case POWER_UP_TYPE_OFFLINE:
            return self.itemsForOffline;
            break;
            
        default:
            break;
    }
}

- (NSArray *)arrayOfitemIdsFor:(PowerUpType)type {
    return [[self dictionaryForType:type] allKeys];
}

- (ShopItem *)shopItemForItemId:(NSString *)itemId dictionary:(PowerUpType)type {
    return [[self dictionaryForType:type] objectForKey:itemId];
}

@end

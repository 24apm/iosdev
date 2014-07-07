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

@property (nonatomic, strong) NSMutableDictionary *itemsForUpgrade;

@property (nonatomic, strong) NSMutableDictionary *itemsForIAP;

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
    return self.itemsForUpgrade;
}

- (NSMutableDictionary *)iapItems {
    return self.itemsForIAP;
}

- (void)createActiveItem:(NSString *)itemId
                    name:(NSString *)name
               imagePath:(NSString *)imagePath
         priceMultiplier:(long long)priceMultipler
       upgradeMultiplier:(long long)upgradeMultiplier
                    rank:(int)rank                 {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_UPGRADE rank:rank];
    [self.itemsForUpgrade setObject:item forKey:item.itemId];
}


- (void)createIAPItem:(NSString *)itemId
                 name:(NSString *)name
            imagePath:(NSString *)imagePath
      priceMultiplier:(long long)priceMultipler
    upgradeMultiplier:(long long)upgradeMultiplier
                 rank:(int)rank                   {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_IAP rank:rank];
    [self.itemsForIAP setObject:item forKey:item.itemId];
}

- (void)setupItems {
    self.itemsForUpgrade = [NSMutableDictionary dictionary];

    self.itemsForIAP = [NSMutableDictionary dictionary];
    
    // ACTIVE
    [self createActiveItem:SHOP_ITEM_ID_UPGRADE_SPEED
                      name:@"Lvl+ Speed"
                 imagePath:@"icon_flylvlup"
           priceMultiplier:100
         upgradeMultiplier:2
                      rank:1];
    
    [self createActiveItem:SHOP_ITEM_ID_UPGRADE_FLAPPY
                      name:@"Lvl+ Recovery"
                 imagePath:@"icon_hprecoverylvlup"
           priceMultiplier:500
         upgradeMultiplier:2
                      rank:2];
    
    [self createActiveItem:SHOP_ITEM_ID_UPGRADE_AIR
                      name:@"Lvl+ HP"
                 imagePath:@"icon_hplvlup"
           priceMultiplier:200
         upgradeMultiplier:2
                      rank:3];

    
    [self createIAPItem:SHOP_ITEM_ID_IAP_FUND
                   name:@"+100000"
              imagePath:@"icon_iap_funding"
        priceMultiplier:-1
      upgradeMultiplier:-1
                   rank:4];
    
    [self createIAPItem:SHOP_ITEM_ID_IAP_DOUBLE_POINTS
                   name:@"x2!"
              imagePath:@"icon_iap_x2"
        priceMultiplier:-1
      upgradeMultiplier:-1
                   rank:1];
    
    [self createIAPItem:SHOP_ITEM_ID_IAD_QUDRUPLE_POINTS
                   name:@"x4!"
              imagePath:@"icon_iap_x4"
        priceMultiplier:-1
      upgradeMultiplier:-1
                   rank:2];
    [self createIAPItem:SHOP_ITEM_ID_IAD_SUPER_POINTS
                   name:@"SUPER!"
              imagePath:@"icon_iap_super"
        priceMultiplier:-1
      upgradeMultiplier:-1
                   rank:3];
}

- (int)itemLevel:(NSString *)itemId type:(PowerUpType)type {
    NSDictionary *userTypeDictionary = [[UserData instance].gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", type]];
    int lvl = [[userTypeDictionary objectForKey:itemId] integerValue] + 1;
    return lvl;
}

- (long long)priceForItemId:(NSString *)itemId type:(PowerUpType)type {
    NSMutableDictionary *tempDictionary = [self dictionaryForType:type];
    ShopItem *shopItem = [tempDictionary objectForKey:itemId];

    int lvl = [self itemLevel:itemId type:type];
    
    long long price = shopItem.priceMultiplier * lvl;
    return price;
}

- (NSMutableDictionary *)dictionaryForType:(PowerUpType)type {
    switch (type) {
        case POWER_UP_TYPE_UPGRADE:
            return self.itemsForUpgrade;
            break;
        case POWER_UP_TYPE_IAP:
            return self.itemsForIAP;
            break;
        default:
            break;
    }
}

- (NSArray *)arrayOfitemIdsFor:(PowerUpType)type {
    NSArray *array = [[self dictionaryForType:type] allKeys];
    
    array = [array sortedArrayUsingComparator:^(id obj1, id obj2) {
        return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
    }];
    return array;
}


- (ShopItem *)shopItemForItemId:(NSString *)itemId dictionary:(PowerUpType)type {
    return [[self dictionaryForType:type] objectForKey:itemId];
}

@end

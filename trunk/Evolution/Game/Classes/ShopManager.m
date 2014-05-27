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
    return self.itemsForTap;
}

- (NSMutableDictionary *)passiveItems {
    return self.itemsForPassive;
}

- (NSMutableDictionary *)offlineItems {
    return self.itemsForOffline;
}

- (NSMutableDictionary *)iapItems {
    return self.itemsForIAP;
}

- (void)createActiveItem:(NSString *)itemId
                    name:(NSString *)name
               imagePath:(NSString *)imagePath
         priceMultiplier:(double)priceMultipler
       upgradeMultiplier:(double)upgradeMultiplier
                    rank:(int)rank                 {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_TAP rank:rank];
    [self.itemsForTap setObject:item forKey:item.itemId];
}

- (void)createPassiveItem:(NSString *)itemId
                     name:(NSString *)name
                imagePath:(NSString *)imagePath
          priceMultiplier:(double)priceMultipler
        upgradeMultiplier:(double)upgradeMultiplier
                     rank:(int)rank                 {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_PASSIVE rank:rank];
    [self.itemsForPassive setObject:item forKey:item.itemId];
}

- (void)createOfflineCapItem:(NSString *)itemId
                        name:(NSString *)name
                   imagePath:(NSString *)imagePath
             priceMultiplier:(double)priceMultipler
           upgradeMultiplier:(double)upgradeMultiplier
                        rank:(int)rank                 {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_OFFLINE_CAP rank:rank];
    [self.itemsForOffline setObject:item forKey:item.itemId];
}

- (void)createOfflineSpeedItem:(NSString *)itemId
                          name:(NSString *)name
                     imagePath:(NSString *)imagePath
               priceMultiplier:(double)priceMultipler
             upgradeMultiplier:(double)upgradeMultiplier
                          rank:(int)rank                   {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_OFFLINE_SPEED rank:rank];
    [self.itemsForOffline setObject:item forKey:item.itemId];
}

- (void)createIAPItem:(NSString *)itemId
                 name:(NSString *)name
            imagePath:(NSString *)imagePath
      priceMultiplier:(double)priceMultipler
    upgradeMultiplier:(double)upgradeMultiplier
                 rank:(int)rank                   {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_IAP rank:rank];
    [self.itemsForIAP setObject:item forKey:item.itemId];
}

- (void)setupItems {
    self.itemsForTap = [NSMutableDictionary dictionary];
    self.itemsForPassive = [NSMutableDictionary dictionary];
    self.itemsForOffline = [NSMutableDictionary dictionary];
    self.itemsForIAP = [NSMutableDictionary dictionary];
    
    // ACTIVE
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_1
                      name:@"Active Tier 1"
                 imagePath:@"icon_cigarette"
           priceMultiplier:20
         upgradeMultiplier:2.f
                      rank:1];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_2
                      name:@"Active Tier 2"
                 imagePath:@"icon_cigarette"
           priceMultiplier:200
         upgradeMultiplier:200
                      rank:2];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_3
                      name:@"Active Tier 3"
                 imagePath:@"icon_cigarette"
           priceMultiplier:20000
         upgradeMultiplier:20000
                      rank:3];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_4
                      name:@"Active Tier 4"
                 imagePath:@"icon_cigarette"
           priceMultiplier:200000
         upgradeMultiplier:200000
                      rank:4];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_5
                      name:@"Active Tier 5"
                 imagePath:@"icon_cigarette"
           priceMultiplier:500000
         upgradeMultiplier:500000
                      rank:5];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_6
                      name:@"Active Tier 6"
                 imagePath:@"icon_cigarette"
           priceMultiplier:2000000
         upgradeMultiplier:2000000
                      rank:6];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_7
                      name:@"Active Tier 7"
                 imagePath:@"icon_cigarette"
           priceMultiplier:5000000
         upgradeMultiplier:5000000
                      rank:7];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_8
                      name:@"Active Tier 8"
                 imagePath:@"icon_cigarette"
           priceMultiplier:1000000
         upgradeMultiplier:1000000
                      rank:8];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_9
                      name:@"Active Tier 9"
                 imagePath:@"icon_cigarette"
           priceMultiplier:5000000
         upgradeMultiplier:5000000
                      rank:9];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_10
                      name:@"Active Tier 10"
                 imagePath:@"icon_cigarette"
           priceMultiplier:200000000
         upgradeMultiplier:200000000
                      rank:10];
    
    
    // PASSIVE
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_1
                       name:@"Passive Tier 1"
                  imagePath:@"icon_cigar"
            priceMultiplier:10
          upgradeMultiplier:0.1f
                       rank:1];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_2
                       name:@"Passive Tier 2"
                  imagePath:@"icon_cigar"
            priceMultiplier:100
          upgradeMultiplier:0.3f
                       rank:2];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_3
                       name:@"Passive Tier 3"
                  imagePath:@"icon_cigar"
            priceMultiplier:3000
          upgradeMultiplier:1.f
                       rank:3];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_4
                       name:@"Passive Tier 4"
                  imagePath:@"icon_cigar"
            priceMultiplier:200000
          upgradeMultiplier:5.f
                       rank:4];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_5
                       name:@"Passive Tier 5"
                  imagePath:@"icon_cigar"
            priceMultiplier:50000
          upgradeMultiplier:10.f
                       rank:5];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_6
                       name:@"Passive Tier 6"
                  imagePath:@"icon_cigar"
            priceMultiplier:500000
          upgradeMultiplier:20.f
                       rank:6];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_7
                       name:@"Passive Tier 7"
                  imagePath:@"icon_cigar"
            priceMultiplier:1000000
          upgradeMultiplier:100.f
                       rank:7];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_8
                       name:@"Passive Tier 8"
                  imagePath:@"icon_cigar"
            priceMultiplier:10000000
          upgradeMultiplier:1000.0f
                       rank:8];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_9
                       name:@"Passive Tier 9"
                  imagePath:@"icon_cigar"
            priceMultiplier:20000000
          upgradeMultiplier:10000.f
                       rank:9];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_10
                       name:@"Passive Tier 10"
                  imagePath:@"icon_cigar"
            priceMultiplier:999999999
          upgradeMultiplier:100000.f
                       rank:10];
    
    
    // OFFLINE
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_1
                          name:@"SOMETHING Level UP"
                     imagePath:@"icon_bucket"
               priceMultiplier:10
             upgradeMultiplier:1.5f
                          rank:1];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_2
                          name:@"SOMETHING Level UP"
                     imagePath:@"icon_bucket"
               priceMultiplier:100
             upgradeMultiplier:1.8f
                          rank:2];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_3
                          name:@"SOMETHING Level UP"
                     imagePath:@"icon_bucket"
               priceMultiplier:3000
             upgradeMultiplier:2.f
                          rank:3];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_4
                          name:@"SOMETHING Level UP"
                     imagePath:@"icon_bucket"
               priceMultiplier:5000
             upgradeMultiplier:2.5f
                          rank:4];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_5
                          name:@"SOMETHING Level UP"
                     imagePath:@"icon_bucket"
               priceMultiplier:10000
             upgradeMultiplier:2.8f
                          rank:5];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_6
                          name:@"SOMETHING Level UP"
                     imagePath:@"icon_bucket"
               priceMultiplier:50000
             upgradeMultiplier:3.f
                          rank:6];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_7
                          name:@"SOMETHING Level UP"
                     imagePath:@"icon_bucket"
               priceMultiplier:100000
             upgradeMultiplier:3.2f
                          rank:7];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_8
                          name:@"SOMETHING Level UP"
                     imagePath:@"icon_bucket"
               priceMultiplier:500000
             upgradeMultiplier:3.5f
                          rank:8];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_9
                          name:@"SOMETHING Level UP"
                     imagePath:@"icon_bucket"
               priceMultiplier:1000000
             upgradeMultiplier:3.8f
                          rank:9];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_10
                          name:@"SOMETHING Level UP"
                     imagePath:@"icon_bucket"
               priceMultiplier:100000000
             upgradeMultiplier:4.f
                          rank:10];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_1
                            name:@"SOMETHING Level UP"
                       imagePath:@"icon_weed"
                 priceMultiplier:10
               upgradeMultiplier:10.f
                            rank:1];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_2
                            name:@"SOMETHING Level UP"
                       imagePath:@"icon_weed"
                 priceMultiplier:100
               upgradeMultiplier:100.f
                            rank:2];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_3
                            name:@"SOMETHING Level UP"
                       imagePath:@"icon_weed"
                 priceMultiplier:1000
               upgradeMultiplier:100.f
                            rank:3];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_4
                            name:@"SOMETHING Level UP"
                       imagePath:@"icon_weed"
                 priceMultiplier:3000
               upgradeMultiplier:100.f
                            rank:4];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_5
                            name:@"SOMETHING Level UP"
                       imagePath:@"icon_weed"
                 priceMultiplier:5000
               upgradeMultiplier:100.f
                            rank:5];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_6
                            name:@"SOMETHING Level UP"
                       imagePath:@"icon_weed"
                 priceMultiplier:10000
               upgradeMultiplier:100.f
                            rank:6];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_7
                            name:@"SOMETHING Level UP"
                       imagePath:@"icon_weed"
                 priceMultiplier:50000
               upgradeMultiplier:100.f
                            rank:7];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_8
                            name:@"SOMETHING Level UP"
                       imagePath:@"icon_weed"
                 priceMultiplier:100000
               upgradeMultiplier:100.f
                            rank:8];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_9
                            name:@"SOMETHING Level UP"
                       imagePath:@"icon_weed"
                 priceMultiplier:500000
               upgradeMultiplier:100.f
                            rank:9];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_10
                            name:@"SOMETHING Level UP"
                       imagePath:@"icon_weed"
                 priceMultiplier:1000000
               upgradeMultiplier:100.f
                            rank:10];
    
    [self createIAPItem:SHOP_ITEM_ID_IAP_FUND
                   name:@"+100000"
              imagePath:@"icon_weed"
        priceMultiplier:-1
      upgradeMultiplier:-1.f
                   rank:4];
    
    [self createIAPItem:SHOP_ITEM_ID_IAP_DOUBLE_POINTS
                   name:@"x2!"
              imagePath:@"icon_weed"
        priceMultiplier:-1
      upgradeMultiplier:-1.f
                   rank:3];
    
    [self createIAPItem:SHOP_ITEM_ID_IAD_QUDRUPLE_POINTS
                   name:@"x4!"
              imagePath:@"icon_weed"
        priceMultiplier:-1
      upgradeMultiplier:-1.f
                   rank:2];
    [self createIAPItem:SHOP_ITEM_ID_IAD_SUPER_POINTS
                   name:@"SUPER!"
              imagePath:@"icon_weed"
        priceMultiplier:-1
      upgradeMultiplier:-1.f
                   rank:5];
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
        case POWER_UP_TYPE_OFFLINE_CAP:
            return self.itemsForOffline;
            break;
        case POWER_UP_TYPE_OFFLINE_SPEED:
            return self.itemsForOffline;
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

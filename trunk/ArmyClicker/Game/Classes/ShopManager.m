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
         priceMultiplier:(long long)priceMultipler
       upgradeMultiplier:(long long)upgradeMultiplier
                    rank:(int)rank                 {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_TAP rank:rank];
    [self.itemsForTap setObject:item forKey:item.itemId];
}

- (void)createPassiveItem:(NSString *)itemId
                     name:(NSString *)name
                imagePath:(NSString *)imagePath
          priceMultiplier:(long long)priceMultipler
        upgradeMultiplier:(long long)upgradeMultiplier
                     rank:(int)rank                 {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_PASSIVE rank:rank];
    [self.itemsForPassive setObject:item forKey:item.itemId];
}

- (void)createOfflineCapItem:(NSString *)itemId
                        name:(NSString *)name
                   imagePath:(NSString *)imagePath
             priceMultiplier:(long long)priceMultipler
           upgradeMultiplier:(long long)upgradeMultiplier
                        rank:(int)rank                 {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_OFFLINE_CAP rank:rank];
    [self.itemsForOffline setObject:item forKey:item.itemId];
}

- (void)createOfflineSpeedItem:(NSString *)itemId
                          name:(NSString *)name
                     imagePath:(NSString *)imagePath
               priceMultiplier:(long long)priceMultipler
             upgradeMultiplier:(long double)upgradeMultiplier
                          rank:(int)rank                   {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_OFFLINE_SPEED rank:rank];
    [self.itemsForOffline setObject:item forKey:item.itemId];
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
    self.itemsForTap = [NSMutableDictionary dictionary];
    self.itemsForPassive = [NSMutableDictionary dictionary];
    self.itemsForOffline = [NSMutableDictionary dictionary];
    self.itemsForIAP = [NSMutableDictionary dictionary];
    
    // ACTIVE
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_1
                      name:@"Lvl 1 Treat"
                 imagePath:@"icon_cigarette"
           priceMultiplier:100
         upgradeMultiplier:2
                      rank:1];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_2
                      name:@"Lvl 2 Treat"
                 imagePath:@"icon_cigarette"
           priceMultiplier:5000
         upgradeMultiplier:5
                      rank:2];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_3
                      name:@"Lvl 3 Treat"
                 imagePath:@"icon_cigarette"
           priceMultiplier:20000
         upgradeMultiplier:10
                      rank:3];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_4
                      name:@"Lvl 4 Treat"
                 imagePath:@"icon_cigarette"
           priceMultiplier:50000
         upgradeMultiplier:15
                      rank:4];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_5
                      name:@"Lvl 5 Treat"
                 imagePath:@"icon_cigarette"
           priceMultiplier:200000
         upgradeMultiplier:20
                      rank:5];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_6
                      name:@"Lvl 6 Treat"
                 imagePath:@"icon_cigarette"
           priceMultiplier:500000
         upgradeMultiplier:30
                      rank:6];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_7
                      name:@"Lvl 7 Treat"
                 imagePath:@"icon_cigarette"
           priceMultiplier:5000000
         upgradeMultiplier:100
                      rank:7];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_8
                      name:@"Lvl 8 Treat"
                 imagePath:@"icon_cigarette"
           priceMultiplier:60000000
         upgradeMultiplier:300
                      rank:8];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_9
                      name:@"Lvl 9 Treat"
                 imagePath:@"icon_cigarette"
           priceMultiplier:100000000
         upgradeMultiplier:800
                      rank:9];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_10
                      name:@"Lvl 10 Treat"
                 imagePath:@"icon_cigarette"
           priceMultiplier:4000000000
         upgradeMultiplier:5000
                      rank:10];
    
    
    // PASSIVE
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_1
                       name:@"Lvl 1 Food"
                  imagePath:@"icon_cigar"
            priceMultiplier:1000
          upgradeMultiplier:10
                       rank:1];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_2
                       name:@"Lvl 2 Food"
                  imagePath:@"icon_cigar"
            priceMultiplier:5000
          upgradeMultiplier:20
                       rank:2];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_3
                       name:@"Lvl 3 Food"
                  imagePath:@"icon_cigar"
            priceMultiplier:30000
          upgradeMultiplier:50
                       rank:3];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_4
                       name:@"Lvl 4 Food"
                  imagePath:@"icon_cigar"
            priceMultiplier:100000
          upgradeMultiplier:100
                       rank:4];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_5
                       name:@"Lvl 5 Food"
                  imagePath:@"icon_cigar"
            priceMultiplier:1000000
          upgradeMultiplier:200
                       rank:5];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_6
                       name:@"Lvl 6 Food"
                  imagePath:@"icon_cigar"
            priceMultiplier:2000000
          upgradeMultiplier:400
                       rank:6];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_7
                       name:@"Lvl 7 Food"
                  imagePath:@"icon_cigar"
            priceMultiplier:5000000
          upgradeMultiplier:1000
                       rank:7];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_8
                       name:@"Lvl 8 Food"
                  imagePath:@"icon_cigar"
            priceMultiplier:10000000
          upgradeMultiplier:5000
                       rank:8];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_9
                       name:@"Lvl 9 Food"
                  imagePath:@"icon_cigar"
            priceMultiplier:150000000
          upgradeMultiplier:10000
                       rank:9];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_10
                       name:@"Lvl 10 Food"
                  imagePath:@"icon_cigar"
            priceMultiplier:20000000000
          upgradeMultiplier:50000
                       rank:10];
    
    
    // OFFLINE
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_1
                          name:@"Lvl 1 Piggy"
                     imagePath:@"icon_bucket"
               priceMultiplier:100
             upgradeMultiplier:2
                          rank:1];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_2
                          name:@"Lvl 2 Piggy"
                     imagePath:@"icon_bucket"
               priceMultiplier:6000
             upgradeMultiplier:6
                          rank:2];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_3
                          name:@"Lvl 3 Piggy"
                     imagePath:@"icon_bucket"
               priceMultiplier:30000
             upgradeMultiplier:12
                          rank:3];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_4
                          name:@"Lvl 4 Piggy"
                     imagePath:@"icon_bucket"
               priceMultiplier:60000
             upgradeMultiplier:20
                          rank:4];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_5
                          name:@"Lvl 5 Piggy"
                     imagePath:@"icon_bucket"
               priceMultiplier:200000
             upgradeMultiplier:30
                          rank:5];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_6
                          name:@"Lvl 6 Piggy"
                     imagePath:@"icon_bucket"
               priceMultiplier:600000
             upgradeMultiplier:40
                          rank:6];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_7
                          name:@"Lvl 7 Piggy"
                     imagePath:@"icon_bucket"
               priceMultiplier:7000000
             upgradeMultiplier:50
                          rank:7];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_8
                          name:@"Lvl 8 Piggy"
                     imagePath:@"icon_bucket"
               priceMultiplier:80000000
             upgradeMultiplier:60
                          rank:8];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_9
                          name:@"Lvl 9 Piggy"
                     imagePath:@"icon_bucket"
               priceMultiplier:120000000
             upgradeMultiplier:80
                          rank:9];
    
    [self createOfflineCapItem:SHOP_ITEM_ID_OFFLINE_CAP_TIER_10
                          name:@"Lvl 10 Piggy"
                     imagePath:@"icon_bucket"
               priceMultiplier:2000000000
             upgradeMultiplier:100
                          rank:10];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_1
                            name:@"Lvl 1 Coin"
                       imagePath:@"icon_weed"
                 priceMultiplier:100
               upgradeMultiplier:0.01f
                            rank:1];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_2
                            name:@"Lvl 2 Coin"
                       imagePath:@"icon_weed"
                 priceMultiplier:8000
               upgradeMultiplier:0.01f
                            rank:2];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_3
                            name:@"Lvl 3 Coin"
                       imagePath:@"icon_weed"
                 priceMultiplier:25000
               upgradeMultiplier:0.01f
                            rank:3];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_4
                            name:@"Lvl 4 Coin"
                       imagePath:@"icon_weed"
                 priceMultiplier:50000
               upgradeMultiplier:0.01f
                            rank:4];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_5
                            name:@"Lvl 5 Coin"
                       imagePath:@"icon_weed"
                 priceMultiplier:150000
               upgradeMultiplier:0.01f
                            rank:5];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_6
                            name:@"Lvl 6 Coin"
                       imagePath:@"icon_weed"
                 priceMultiplier:400000
               upgradeMultiplier:0.01f
                            rank:6];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_7
                            name:@"Lvl 7 Coin"
                       imagePath:@"icon_weed"
                 priceMultiplier:2000000
               upgradeMultiplier:0.01f
                            rank:7];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_8
                            name:@"Lvl 8 Coin"
                       imagePath:@"icon_weed"
                 priceMultiplier:30000000
               upgradeMultiplier:0.01f
                            rank:8];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_9
                            name:@"Lvl 9 Coin"
                       imagePath:@"icon_weed"
                 priceMultiplier:200000000
               upgradeMultiplier:0.01f
                            rank:9];
    
    [self createOfflineSpeedItem:SHOP_ITEM_ID_OFFLINE_SPEED_TIER_10
                            name:@"Lvl 10 Coin"
                       imagePath:@"icon_weed"
                 priceMultiplier:50000000000
               upgradeMultiplier:0.01f
                            rank:10];
    
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

- (long long)priceForItemId:(NSString *)itemId type:(PowerUpType)type {
    NSMutableDictionary *tempDictionary = [self dictionaryForType:type];
    ShopItem *shopItem = [tempDictionary objectForKey:itemId];
    NSDictionary *userTypeDictionary = [[UserData instance].gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", type]];
    int lvl = [[userTypeDictionary objectForKey:itemId] integerValue] + 1;
    
    long long price = shopItem.priceMultiplier * lvl;
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

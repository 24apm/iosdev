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

- (void)createActiveItem:(NSString *)itemId
                          name:(NSString *)name
                     imagePath:(NSString *)imagePath
               priceMultiplier:(float)priceMultipler
             upgradeMultiplier:(float)upgradeMultiplier {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_TAP];
    [self.itemsForTap setObject:item forKey:item.itemId];
}

- (void)createPassiveItem:(NSString *)itemId
                    name:(NSString *)name
               imagePath:(NSString *)imagePath
         priceMultiplier:(float)priceMultipler
       upgradeMultiplier:(float)upgradeMultiplier {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_PASSIVE];
    [self.itemsForPassive setObject:item forKey:item.itemId];
}

- (void)createOfflineItem:(NSString *)itemId
                     name:(NSString *)name
                imagePath:(NSString *)imagePath
          priceMultiplier:(float)priceMultipler
        upgradeMultiplier:(float)upgradeMultiplier {
    
    ShopItem *item = [ShopItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:POWER_UP_TYPE_OFFLINE];
    [self.itemsForOffline setObject:item forKey:item.itemId];
}


- (void)setupItems {
    self.itemsForTap = [NSMutableDictionary dictionary];
    self.itemsForPassive = [NSMutableDictionary dictionary];
    self.itemsForOffline = [NSMutableDictionary dictionary];
    
    // ACTIVE
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_1
                       name:@"Tap Level UP"
                  imagePath:@"icon_cigarette"
            priceMultiplier:20
          upgradeMultiplier:2.f];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_2
                      name:@"Tap Level UP"
                 imagePath:@"icon_cigarette"
           priceMultiplier:200
         upgradeMultiplier:200.f];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_3
                      name:@"Tap Level UP"
                 imagePath:@"icon_cigarette"
           priceMultiplier:20000
         upgradeMultiplier:2000.f];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_4
                      name:@"Tap Level UP"
                 imagePath:@"icon_cigarette"
           priceMultiplier:200000
         upgradeMultiplier:50000.f];
    
    [self createActiveItem:SHOP_ITEM_ID_ACTIVE_TIER_10
                      name:@"Tap Level UP"
                 imagePath:@"icon_cigarette"
           priceMultiplier:200000000
         upgradeMultiplier:20.f];
    
    
    
    // PASSIVE
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_1
                       name:@"Passive Level UP"
                  imagePath:@"icon_cigar"
            priceMultiplier:10
          upgradeMultiplier:0.3f];
    
    [self createPassiveItem:SHOP_ITEM_ID_PASSIVE_TIER_2
                       name:@"Passive Level UP"
                  imagePath:@"icon_cigar"
            priceMultiplier:100
          upgradeMultiplier:3.3f];
    
    
    
    // OFFLINE
    [self createOfflineItem:SHOP_ITEM_ID_OFFLINE_TIER_1
                       name:@"SOMETHING Level UP"
                  imagePath:@"icon_weed"
            priceMultiplier:100
          upgradeMultiplier:1.f];
    
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

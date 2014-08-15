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

@property (nonatomic, strong) NSMutableDictionary *priceDictionary;

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
         priceMultiplier:(long double)priceMultipler
       upgradeMultiplier:(long double)upgradeMultiplier
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
    
    self.priceDictionary = [NSMutableDictionary dictionary];
    [self createDictionaryForPrice];
    
    
    [self createIAPItem:SHOP_ITEM_ID_IAP_FUND
                   name:@"+Private Tutor"
              imagePath:@"tutor"
        priceMultiplier:-1
      upgradeMultiplier:-1
                   rank:4];
    
    [self createIAPItem:SHOP_ITEM_ID_IAP_DOUBLE_POINTS
                   name:@"Sleeping"
              imagePath:@"dream"
        priceMultiplier:-1
      upgradeMultiplier:-1
                   rank:1];
    
    [self createIAPItem:SHOP_ITEM_ID_IAD_QUDRUPLE_POINTS
                   name:@"Meditate"
              imagePath:@"meditate"
        priceMultiplier:-1
      upgradeMultiplier:-1
                   rank:2];
    [self createIAPItem:SHOP_ITEM_ID_IAD_SUPER_POINTS
                   name:@"Enlightment"
              imagePath:@"enlightment"
        priceMultiplier:-1
      upgradeMultiplier:-1
                   rank:3];
    
}

- (long long)priceForItemId:(NSString *)itemId type:(PowerUpType)type {
    NSMutableDictionary *tempDictionary = [self dictionaryForType:type];
    ShopItem *shopItem = [tempDictionary objectForKey:itemId];
    
    int lvl = 1;
    long long price = shopItem.priceMultiplier * [self lookUpDictionaryForLvl:lvl];
    price = [self trucateNumber:price numOfDigits:price > 100 ? 2 : 1];
    return price;
}


- (double)lookUpDictionaryForLvl:(int)lvl {
    return [[self.priceDictionary objectForKey:[NSString stringWithFormat:@"%d", lvl]] doubleValue];
}


- (void)createDictionaryForPrice {
    [self lvlModifier];
}

- (double)lvlModifier {
    float basePower = 1.09;
    float finalPower = 1.01;
    float offsetPower = 0.6;
    float base = 0;
    
    double compound = 1;
    for (int i = 0; i <= 100; i++) {
        base = ((basePower - (basePower - finalPower)/100.f * i) + offsetPower);
        offsetPower -= 0.03;
        if (offsetPower <= 0) {
            offsetPower = 0;
        }
        compound *= base;
        [self.priceDictionary setObject:[NSNumber numberWithDouble:compound] forKey:[NSString stringWithFormat:@"%d", i ]];
    }
    return compound;
}

- (double)trucateNumber:(double)number numOfDigits:(int)numOfDigits {
    // 7
    int length = (number == 0) ? 1 : (int)log10(number) + 1;
    
    // 1,000,000
    int dividend = pow(10, length - numOfDigits);
    
    // 7,234,567 / 1,000,000
    // 7
    int remainder = number / dividend;
    
    // 7 * 1,000,000
    // 7,000,000
    int truncatedCost = remainder * dividend;
    
    return truncatedCost;
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

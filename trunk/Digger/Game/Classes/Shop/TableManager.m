//
//  ShopItems.m
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "TableManager.h"
#import "UserData.h"
#import "TreasureData.h"

@interface TableManager()

@property (nonatomic, strong) NSMutableDictionary *itemsForUpgrade;
@property (nonatomic, strong) NSMutableDictionary *itemsForInventory;
@property (nonatomic, strong) NSMutableDictionary *itemsForIAP;

@property (nonatomic, strong) NSMutableDictionary *priceDictionary;

@end

@implementation TableManager

+ (TableManager *)instance {
    static TableManager *instance = nil;
    if (!instance) {
        instance = [[TableManager alloc] init];
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

- (void)createWaypointItem:(NSString *)itemId
                      name:(NSString *)name
                 imagePath:(NSString *)imagePath
                     level:(NSUInteger)level
                      rank:(int)rank                 {
    
    WaypointRowItem *item = [WaypointRowItem createItem:itemId name:name imagePath:imagePath level:level type:TableTypeWaypoint rank:rank];
    [self.itemsForUpgrade setObject:item forKey:item.itemId];
}

- (void)createInventoryItem:(NSString *)itemId
                       name:(NSString *)name
           descriptionLabel:(NSString *)descriptionLabel
                  imagePath:(NSString *)imagePath
                       rank:(int)rank
                      state:(KnapsackState)state     {
    
    InventoryRowItem *item = [InventoryRowItem createItem:(NSString *)itemId name:name descriptionLabel:descriptionLabel imagePath:imagePath type:TableTypeWaypoint rank:rank state:state];
    [self.itemsForInventory setObject:item forKey:item.itemId];
}


- (void)createIAPItem:(NSString *)itemId
                 name:(NSString *)name
            imagePath:(NSString *)imagePath
      priceMultiplier:(long long)priceMultipler
    upgradeMultiplier:(long long)upgradeMultiplier
                 rank:(int)rank                   {
    
    IAPRowItem *item = [IAPRowItem createItem:itemId name:name imagePath:imagePath priceMultiplier:priceMultipler upgradeMultiplier:upgradeMultiplier type:TableTypeIAP rank:rank];
    [self.itemsForIAP setObject:item forKey:item.itemId];
}

- (void)setupInventoryItems {
    self.itemsForInventory = [NSMutableDictionary dictionary];
    for (NSUInteger i = 0; i < [UserData instance].knapsack.count; i++) {
        NSUInteger currentRank = [[[UserData instance].knapsack objectAtIndex:i] integerValue];
        TreasureData *data = [[TreasureData alloc] init];
        data = [data setupItemWithRank:currentRank];
        NSString *name = data.name;
        NSString *icon = data.icon;
        NSString *descriptionLabel = data.descriptionLabel;
        NSUInteger rank = currentRank;
        NSString *itemID = [NSString stringWithFormat:@"%d",i];
        KnapsackState state = KnapsackStateOccupy;
        [self createInventoryItem:itemID name:name descriptionLabel:descriptionLabel imagePath:icon rank:rank state:state];
    }
    
    if (![[UserData instance]isKnapsackFull]) {
        for (NSUInteger i = [UserData instance].knapsack.count; i < [UserData instance].knapsackCapacity; i++) {
            
            NSString *name = @"";
            NSString *icon = @"";
            NSString *descriptionLabel = @"";
            NSUInteger rank = 0;
            NSString *itemID = [NSString stringWithFormat:@"%d",i];
            KnapsackState state = KnapsackStateEmpty;
            [self createInventoryItem:itemID name:name descriptionLabel:descriptionLabel imagePath:icon rank:rank state:state];
        }
    }
    
    
    if ([[UserData instance]isKnapsackOverWeight]) {
        for (NSUInteger i = [UserData instance].knapsackCapacity; i < [UserData instance].knapsack.count; i++) {
            
            NSUInteger currentRank = [[[UserData instance].knapsack objectAtIndex:i] integerValue];
            TreasureData *data = [[TreasureData alloc] init];
            data = [data setupItemWithRank:currentRank];
            NSString *name = data.name;
            NSString *icon = data.icon;
            NSString *descriptionLabel = data.descriptionLabel;
            NSUInteger rank = currentRank;
            NSString *itemID = [NSString stringWithFormat:@"%d",i];
            KnapsackState state = KnapsackStateOverWeight;
            [self createInventoryItem:itemID name:name descriptionLabel:descriptionLabel imagePath:icon rank:rank state:state];
        }
    }
}

- (void)setupItems {
    [self setupInventoryItems];
    self.itemsForUpgrade = [NSMutableDictionary dictionary];
    
    self.itemsForIAP = [NSMutableDictionary dictionary];
    
    self.priceDictionary = [NSMutableDictionary dictionary];
    [self createDictionaryForPrice];
    
    [self createWaypointItem:WAYPOINT_ITEM_ID_1
                        name:@"Waypoint 1"
                   imagePath:@"icon_flap"
                       level:10
                        rank:1];
    [self createWaypointItem:WAYPOINT_ITEM_ID_2
                        name:@"Waypoint 2"
                   imagePath:@"icon_flap"
                       level:20
                        rank:2];
    [self createWaypointItem:WAYPOINT_ITEM_ID_3
                        name:@"Waypoint 3"
                   imagePath:@"icon_flap"
                       level:30
                        rank:3];
    [self createWaypointItem:WAYPOINT_ITEM_ID_4
                        name:@"Waypoint 4"
                   imagePath:@"icon_flap"
                       level:40
                        rank:4];
    [self createWaypointItem:WAYPOINT_ITEM_ID_5
                        name:@"Waypoint 5"
                   imagePath:@"icon_flap"
                       level:50
                        rank:5];
    [self createWaypointItem:WAYPOINT_ITEM_ID_6
                        name:@"Waypoint 6"
                   imagePath:@"icon_flap"
                       level:60
                        rank:6];
    [self createWaypointItem:WAYPOINT_ITEM_ID_7
                        name:@"Waypoint 7"
                   imagePath:@"icon_flap"
                       level:70
                        rank:7];
    
    
    [self createIAPItem:SHOP_ITEM_ID_IAP_FUND
                   name:@"Stack of Cash"
              imagePath:@"stackmoney"
        priceMultiplier:-1
      upgradeMultiplier:-1
                   rank:4];
    
    [self createIAPItem:SHOP_ITEM_ID_IAD_FUND2
                   name:@"Bag of Cash"
              imagePath:@"bagmoney"
        priceMultiplier:-1
      upgradeMultiplier:-1
                   rank:1];
    
    [self createIAPItem:SHOP_ITEM_ID_IAD_FUND3
                   name:@"Case of Cash"
              imagePath:@"casemoney"
        priceMultiplier:-1
      upgradeMultiplier:-1
                   rank:2];
    [self createIAPItem:SHOP_ITEM_ID_IAD_FUND4
                   name:@"Cash Bath"
              imagePath:@"moneybath"
        priceMultiplier:-1
      upgradeMultiplier:-1
                   rank:3];
    
}

- (long long)priceForItemId:(NSString *)itemId type:(TableType)type {
    NSMutableDictionary *tempDictionary = [self dictionaryForType:type];
    ShopRowItem *shopItem = [tempDictionary objectForKey:itemId];
    
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


- (NSMutableDictionary *)dictionaryForType:(TableType)type {
    switch (type) {
        case TableTypeWaypoint:
            return self.itemsForUpgrade;
            break;
        case TableTypeInventory:
            return self.itemsForInventory;
            break;
        case TableTypeIAP:
            return self.itemsForIAP;
            break;
        default:
            break;
    }
    return  nil;
}

- (NSArray *)arrayOfitemIdsFor:(TableType)type {
    NSArray *array = [[self dictionaryForType:type] allKeys];
    
    array = [array sortedArrayUsingComparator:^(id obj1, id obj2) {
        return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
    }];
    return array;
}

- (NSArray *)arrayOfInventory {
    [self setupInventoryItems];
    return [self.itemsForInventory allKeys];
}


- (ShopRowItem *)shopItemForItemId:(NSString *)itemId dictionary:(TableType)type {
    return [[self dictionaryForType:type] objectForKey:itemId];
}

- (WaypointRowItem *)waypointItemForItemId:(NSString *)itemId dictionary:(TableType)type {
    return [[self dictionaryForType:type] objectForKey:itemId];
}

- (InventoryRowItem *)inventoryItemForItemId:(NSString *)itemId dictionary:(TableType)type {
    return [[self dictionaryForType:type] objectForKey:itemId];
}
@end

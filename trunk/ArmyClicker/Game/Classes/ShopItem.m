//
//  ShopItem.m
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ShopItem.h"

@implementation ShopItem

+ (ShopItem *)createItem:(NSString *)itemId
                    name:(NSString *)name
               imagePath:(NSString *)imagePath
         priceMultiplier:(float)priceMultipler
       upgradeMultiplier:(float)upgradeMultiplier
                    type:(PowerUpType)type {
    
    ShopItem *item = [[ShopItem alloc] init];
    item.name = name;
    item.imagePath = imagePath;
    item.itemId = itemId;
    item.priceMultiplier = priceMultipler;
    item.upgradeMultiplier = upgradeMultiplier;
    item.type = type;
    return item;
}

- (NSString *)formatDescriptionWithValue:(float)value {
    NSString *temp = nil;
    switch (self.type) {
        case POWER_UP_TYPE_TAP:
            temp = [self descriptionForActive:value];
            break;
        case POWER_UP_TYPE_PASSIVE:
            temp = [self descriptionForPassive:value];
            break;
        case POWER_UP_TYPE_OFFLINE:
            temp = [self descriptionForOffline:value];
            break;
        default:
            break;
    }
    return temp;
}

- (NSString *)descriptionForActive:(float)value {
    return [NSString stringWithFormat:@"+$%d", (int)value];
}

- (NSString *)descriptionForPassive:(float)value {
    return [NSString stringWithFormat:@"+$%0.1f/sec", value];
}

- (NSString *)descriptionForOffline:(float)value {
    return [NSString stringWithFormat:@"+$%d/hr", (int)value];
}


@end

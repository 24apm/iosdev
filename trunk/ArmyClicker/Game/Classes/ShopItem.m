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
         priceMultiplier:(double)priceMultipler
       upgradeMultiplier:(double)upgradeMultiplier
                    type:(PowerUpType)type
                    rank:(int)rank           {
    
    ShopItem *item = [[ShopItem alloc] init];
    item.name = name;
    item.imagePath = imagePath;
    item.itemId = itemId;
    item.priceMultiplier = priceMultipler;
    item.upgradeMultiplier = upgradeMultiplier;
    item.type = type;
    item.rank = rank;
    return item;
}

- (NSString *)formatDescriptionWithValue:(double)value {
    NSString *temp = nil;
    switch (self.type) {
        case POWER_UP_TYPE_TAP:
            temp = [self descriptionForActive:value];
            break;
        case POWER_UP_TYPE_PASSIVE:
            temp = [self descriptionForPassive:value];
            break;
        case POWER_UP_TYPE_OFFLINE_CAP:
            temp = [self descriptionForOfflineCap:value];
            break;
        case POWER_UP_TYPE_OFFLINE_SPEED:
            temp = [self descriptionForOfflineSpeed:value];
            break;
        default:
            break;
    }
    return temp;
}

- (UIColor *)tierColor:(int)tier {
    switch (tier) {
        case 1:
            return [UIColor whiteColor];
            break;
        case 2:
            return [UIColor yellowColor];
            break;
        case 3:
            return [UIColor orangeColor];
            break;
        case 4:
            return [UIColor greenColor];
            break;
        case 5:
            return [UIColor blueColor];
            break;
        case 6:
            return [UIColor purpleColor];
            break;
        case 7:
            return [UIColor brownColor];
            break;
        case 8:
            return [UIColor redColor];
            break;
        case 9:
            return [UIColor magentaColor];
            break;
        case 10:
            return [UIColor blackColor];
            break;
        default:
            break;
    }
    return [UIColor whiteColor];
}

- (NSString *)descriptionForActive:(float)value {
    return [NSString stringWithFormat:@"+$%d", (int)value];
}

- (NSString *)descriptionForPassive:(float)value {
    return [NSString stringWithFormat:@"+$%0.1f/sec", value];
}

- (NSString *)descriptionForOfflineCap:(float)value {
    return [NSString stringWithFormat:@"+%.1fhr", value];
}

- (NSString *)descriptionForOfflineSpeed:(float)value {
    return [NSString stringWithFormat:@"-%dsec", (int)value];
}

@end

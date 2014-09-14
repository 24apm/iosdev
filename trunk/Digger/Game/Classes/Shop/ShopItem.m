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
         priceMultiplier:(long long)priceMultipler
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
        case POWER_UP_TYPE_IAP:
            temp = [self descriptionForIAP:value];
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
            return [UIColor whiteColor];
            break;
        case 3:
            return [UIColor whiteColor];
            break;
        case 4:
            return [UIColor whiteColor];
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

- (NSString *)descriptionForIAP:(float)value {
    int currentRank = self.rank;
    switch (currentRank) {
        case 4:
            return @"+$5,000!";
            break;
        case 1:
            return @"+$20,000!!";
            break;
        case 2:
            return @"+$100,000!!!";
            break;
        case 3:
            return @"+$10,000,000!!!!";
            break;
        default:
            break;
    }
    return @"Item not found error";
    
}

@end

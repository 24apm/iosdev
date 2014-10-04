//
//  ShopItem.m
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "WaypointRowItem.h"

@implementation WaypointRowItem

+ (WaypointRowItem *)createItem:(NSString *)itemId
                    name:(NSString *)name
               imagePath:(NSString *)imagePath
                   level:(NSUInteger)level
                    type:(TableType)type
                    rank:(int)rank           {
    
    WaypointRowItem *item = [[WaypointRowItem alloc] init];
    item.name = name;
    item.imagePath = imagePath;
    item.itemId = itemId;
    item.level = level;
    item.type = type;
    item.rank = rank;
    return item;
}

- (NSString *)formatDescription {

    return [NSString stringWithFormat:@"Travel to depth:%d!", self.level];
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

@end

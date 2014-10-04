//
//  ShopItem.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"

@interface WaypointRowItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic) NSString * itemId;
@property (nonatomic) NSUInteger level;
@property (nonatomic) TableType type;
@property (nonatomic) NSUInteger rank;

+ (WaypointRowItem *)createItem:(NSString *)itemId
                    name:(NSString *)name
               imagePath:(NSString *)imagePath
                   level:(NSUInteger)level
                    type:(TableType)type
                    rank:(int)rank;

- (NSString *)formatDescription;
- (UIColor *)tierColor:(int)tier;

@end

//
//  ShopItem.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"

@interface IAPRowItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic) NSString * itemId;
@property (nonatomic) long long priceMultiplier;
@property (nonatomic) double value;
@property (nonatomic) TableType type;
@property (nonatomic) double upgradeMultiplier;
@property (nonatomic) int rank;

+ (IAPRowItem *)createItem:(NSString *)itemId
                    name:(NSString *)name
               imagePath:(NSString *)imagePath
         priceMultiplier:(long long)priceMultipler
       upgradeMultiplier:(double)upgradeMultiplier
                    type:(TableType)type
                    rank:(int)rank;

- (NSString *)formatDescriptionWithValue:(double)value;
- (UIColor *)tierColor:(int)tier;

@end

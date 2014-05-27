//
//  ShopItem.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"

@interface ShopItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic) NSString * itemId;
@property (nonatomic) int priceMultiplier;
@property (nonatomic) double value;
@property (nonatomic) PowerUpType type;
@property (nonatomic) double upgradeMultiplier;
@property (nonatomic) int rank;

+ (ShopItem *)createItem:(NSString *)itemId
                    name:(NSString *)name
               imagePath:(NSString *)imagePath
         priceMultiplier:(double)priceMultipler
       upgradeMultiplier:(double)upgradeMultiplier
                    type:(PowerUpType)type
                    rank:(int)rank;

- (NSString *)formatDescriptionWithValue:(double)value;
- (UIColor *)tierColor:(int)tier;

@end

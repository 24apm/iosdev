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
@property (nonatomic) float value;
@property (nonatomic) PowerUpType type;
@property (nonatomic) float upgradeMultiplier;

+ (ShopItem *)createItem:(NSString *)itemId
                    name:(NSString *)name
               imagePath:(NSString *)imagePath
         priceMultiplier:(float)priceMultipler
       upgradeMultiplier:(float)upgradeMultiplier
                    type:(PowerUpType)type;

- (NSString *)formatDescriptionWithValue:(float)value;
- (UIColor *)tierColor:(int)tier;

@end

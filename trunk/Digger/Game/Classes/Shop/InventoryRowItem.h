//
//  ShopItem.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"

@interface InventoryRowItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic) NSString * itemId;
@property (nonatomic, strong) NSString * descriptionLabel;
@property (nonatomic) double value;
@property (nonatomic) TableType type;
@property (nonatomic) int rank;
@property (nonatomic) KnapsackState state;

+ (InventoryRowItem *)createItem:(NSString *)itemId
                            name:(NSString *)name
                descriptionLabel:(NSString *)descriptionLabel
                       imagePath:(NSString *)imagePath
                            type:(TableType)type
                            rank:(int)rank
                           state:(KnapsackState)state;

- (NSString *)formatDescriptionWithValue:(double)value;
- (UIColor *)tierColor:(int)tier;

@end

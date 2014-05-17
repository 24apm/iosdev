//
//  ShopItem.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic) NSString * itemId;
@property (nonatomic) int priceMultiplier;
@property (nonatomic) float value;
@property (nonatomic) int type;
@property (nonatomic) float upgradeMultiplier;

- (void)setupName:(NSString *)name
      description:(NSString *)description
        imagePath:(NSString *)imagePath
           itemId:(NSString *)itemId;

@end

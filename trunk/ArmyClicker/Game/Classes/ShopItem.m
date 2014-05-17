//
//  ShopItem.m
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ShopItem.h"

@implementation ShopItem

- (void)setupName:(NSString *)name description:(NSString *)description imagePath:(NSString *)imagePath itemId:(NSString *)itemId {
    self.name = name;
    self.description = description;
    self.imagePath = imagePath;
    self.itemId = itemId;
}

@end

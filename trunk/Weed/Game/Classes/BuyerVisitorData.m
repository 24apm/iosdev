//
//  BuyerVisitorData.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BuyerVisitorData.h"

@implementation BuyerVisitorData

- (id)init {
    self = [super init];
    if (self) {
        self.houseData = [[HouseData alloc] init];
    }
    return self;
}

@end

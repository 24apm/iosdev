//
//  HouseData.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "HouseData.h"

@implementation HouseData

+ (HouseData *)defaultData {
    HouseData *houseData = [[HouseData alloc] init];
    houseData.id = 0;
    houseData.cost = 1000000;
    houseData.imagePath = @"House.png";
    return houseData;
}

- (NSDictionary *)dictionary {
    return @{@"id": @(self.id),
             @"cost": @(self.cost),
             @"imagePath": self.imagePath};
}

- (void)setupWithDict:(NSDictionary *)dict {
    self.id = [[dict objectForKey:@"id"] integerValue];
    self.cost = [[dict objectForKey:@"cost"] longLongValue];
    self.imagePath = [dict objectForKey:@"imagePath"];
}

@end

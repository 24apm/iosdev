//
//  RenterData.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RenterData.h"
#import "Utils.h"
#import "RealEstateManager.h"

@implementation RenterData

+ (RenterData *)dummyData {
    RenterData *data = [[RenterData alloc] init];
    
    int maxRand = CLAMP([[RealEstateManager instance] userMaxHouseSize] + 1, 1, 9);
    data.count = [Utils randBetweenMinInt:1 max:maxRand];
    data.cost = [Utils randBetweenMinInt:10 max:100] * pow(data.count, 2);
    data.duration = pow(2,data.count) * 60; // 2 - 10 mins
    return data;
}

- (RenterData *)initWithDict:(NSDictionary *)dict {
    RenterData *data = [[RenterData alloc] init];
    [data setupWithDict:dict];
    return data;
}

- (NSDictionary *)dictionary {
    return @{@"duration": @(self.duration),
             @"cost": @(self.cost),
             @"count": @(self.count),
             @"timeDue":@(self.timeDue)};
}

- (void)setupWithDict:(NSDictionary *)dict {
    self.duration = [[dict objectForKey:@"duration"] doubleValue];
    self.cost = [[dict objectForKey:@"cost"] longLongValue];
    self.count = [[dict objectForKey:@"count"] integerValue];
    self.timeDue = [[dict objectForKey:@"timeDue"] doubleValue];
}

@end

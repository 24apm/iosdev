//
//  RenterData.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RenterData.h"
#import "Utils.h"
#import "LevelManager.h"

@implementation RenterData

+ (RenterData *)dummyData {
    RenterData *data = [[RenterData alloc] init];
    data.count = [[LevelManager instance] generateRenterCount];
    data.duration = [[LevelManager instance] generateRenterDuration];
    data.cost =  [[LevelManager instance] generateRenterRate:data.count duration:data.duration];
    data.contractCurrentCount = 0;
    data.contractExpired = [[LevelManager instance] generateRenterContractExpired];
    data.imagePath = [[LevelManager instance] generateRenterImagePath];
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
             @"timeDue":@(self.timeDue),
             @"contractExpired":@(self.contractExpired),
             @"contractCurrentCount":@(self.contractCurrentCount),
             @"imagePath":self.imagePath};
}

- (void)setupWithDict:(NSDictionary *)dict {
    self.duration = [[dict objectForKey:@"duration"] doubleValue];
    self.cost = [[dict objectForKey:@"cost"] longLongValue];
    self.count = (int)[[dict objectForKey:@"count"] integerValue];
    self.timeDue = [[dict objectForKey:@"timeDue"] doubleValue];
    self.contractExpired = (int)[[dict objectForKey:@"contractExpired"] integerValue];
    self.contractCurrentCount = (int)[[dict objectForKey:@"contractCurrentCount"] integerValue];
    self.imagePath = [dict objectForKey:@"imagePath"];
}

@end

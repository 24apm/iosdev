//
//  HouseData.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "HouseData.h"

@implementation HouseData

+ (HouseData *)dummyData {
    HouseData *houseData = [[HouseData alloc] init];
    houseData.id = 0;
    houseData.cost = 10;
    houseData.imagePath = @"House.png";
    houseData.renterData = [RenterData dummyData];
    return houseData;
}

- (NSDictionary *)dictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@(self.id) forKey:@"id"];
    [dic setObject:@(self.cost) forKey:@"cost"];
    [dic setObject:self.imagePath forKey:@"imagePath"];
    
    if (self.renterData) {
        [dic setObject:[self.renterData dictionary] forKey:@"renterData"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dic];
}

- (void)setupWithDict:(NSDictionary *)dict {
    self.id = [[dict objectForKey:@"id"] integerValue];
    self.cost = [[dict objectForKey:@"cost"] longLongValue];
    self.imagePath = [dict objectForKey:@"imagePath"];
    self.renterData = [[RenterData alloc] initWithDict:[dict objectForKey:@"renterData"]];
}

@end

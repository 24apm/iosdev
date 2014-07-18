//
//  HouseData.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "HouseData.h"
#import "Utils.h"
#import "RealEstateManager.h"

@implementation HouseData

+ (HouseData *)defaultData {
    HouseData *houseData = [[HouseData alloc] init];
    houseData.id = 0;
    houseData.cost = 10;
    houseData.renterData = nil;
    houseData.unitSize = 1;
    return houseData;
}

+ (HouseData *)dummyData {
    HouseData *houseData = [[HouseData alloc] init];
    houseData.id = 0;
    houseData.renterData = nil;
    
    float showNextLevelContentThreshold = [Utils randBetweenMin:0.f max:1.0f];
    int count = 0;
    int userMaxHouseSize = [[RealEstateManager instance] userMaxHouseSize];
    if (showNextLevelContentThreshold > 0.8f) {
        count = userMaxHouseSize + 1;
    } else {
        count = [Utils randBetweenMinInt:1 max:userMaxHouseSize];
    }
    houseData.unitSize = CLAMP(count, 1, 9);
    houseData.cost = [Utils randBetweenMinInt:100 max:1000] * pow(houseData.unitSize, 3);
    return houseData;
}

- (NSDictionary *)dictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@(self.id) forKey:@"id"];
    [dic setObject:@(self.cost) forKey:@"cost"];
    [dic setObject:@(self.unitSize) forKey:@"unitSize"];

    if (self.renterData) {
        [dic setObject:[self.renterData dictionary] forKey:@"renterData"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dic];
}

- (void)setupWithDict:(NSDictionary *)dict {
    self.id = [[dict objectForKey:@"id"] integerValue];
    self.cost = [[dict objectForKey:@"cost"] longLongValue];
    self.unitSize = [[dict objectForKey:@"unitSize"] integerValue];

    if ([dict objectForKey:@"renterData"]) {
        self.renterData = [[RenterData alloc] initWithDict:[dict objectForKey:@"renterData"]];
    } else {
        self.renterData = nil;
    }
}

@end

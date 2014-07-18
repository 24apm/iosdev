//
//  BuyerVisitorData.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BuyerVisitorData.h"
#import "UserData.h"
#import "Utils.h"

@implementation BuyerVisitorData

+ (BuyerVisitorData *)dummyData {
    BuyerVisitorData *data = [[BuyerVisitorData alloc] init];
    data.houseData = [[UserData instance] randomUserHouse];
    data.imagePath = @"NGIcon120.png";
    data.name = @"Some Buyer";
    data.occupation = @"Doctor";
    data.priceModifier = [Utils randBetweenMin:0.2 max:2.0];
    return data;
}

- (int)buyerPrice {
    return (int)(self.houseData.cost * self.priceModifier);
}

@end

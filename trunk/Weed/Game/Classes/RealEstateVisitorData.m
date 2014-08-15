//
//  RealEstateVisitorData.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RealEstateVisitorData.h"

@implementation RealEstateVisitorData

- (id)init {
    self = [super init];
    if (self) {
        self.houseData = [[HouseData alloc] init];
    }
    return self;
}

+ (RealEstateVisitorData *)dummyData {
    RealEstateVisitorData *data = [[RealEstateVisitorData alloc] init];
    data.houseData = [HouseData dummyData];
    data.imagePath = @"bubble.png";
    data.name = @"Some Seller";
    data.occupation = @"Realtor";
    data.messageBubble = [NSString stringWithFormat:@"Selling %d bedroom(s) house!", data.houseData.unitSize];
    return data;
}


@end

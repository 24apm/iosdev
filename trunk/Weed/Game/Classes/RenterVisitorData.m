//
//  RenterVisitorData.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RenterVisitorData.h"

@implementation RenterVisitorData

+ (RenterVisitorData *)dummyData {
    RenterVisitorData *data = [[RenterVisitorData alloc] init];
    data.renterData = [RenterData dummyData];
    data.imagePath = @"FlappyBallIcon100x100.png";

    return data;
}

@end

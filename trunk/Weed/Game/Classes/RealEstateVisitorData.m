//
//  RealEstateVisitorData.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RealEstateVisitorData.h"
#import "PeopleData.h"

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
    Gender gender = [[PeopleData randomGender] intValue];
    data.houseData = [HouseData dummyData];
    data.imagePath = [PeopleData generateFace:gender];
    data.name = [PeopleData randomName:gender];
    data.occupation = @"is selling this house";
    data.messageBubble = [NSString stringWithFormat:@"Selling %d bedroom(s) house!", data.houseData.unitSize];
    return data;
}

@end

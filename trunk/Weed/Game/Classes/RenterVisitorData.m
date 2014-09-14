//
//  RenterVisitorData.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RenterVisitorData.h"
#import "PeopleData.h"

@implementation RenterVisitorData

+ (RenterVisitorData *)dummyData {
    RenterVisitorData *data = [[RenterVisitorData alloc] init];
    data.renterData = [RenterData dummyData];
    Gender gender = [[PeopleData randomGender] intValue];
    data.RenterData = [RenterData dummyData];
    data.imagePath = [PeopleData generateFace:gender];
    data.name = [PeopleData randomName:gender];
    data.occupation = [PeopleData randomJob];
    data.messageBubble = [NSString stringWithFormat:@"Looking for %d room(s)", data.renterData.count];
    data.gender = gender;
    return data;
}

@end

//
//  HouseData.h
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenterData.h"

@interface HouseData : NSObject

@property (strong, nonatomic) RenterData *renterData;
@property (nonatomic) int id;
@property (nonatomic) long long cost;
@property (strong, nonatomic) NSString *imagePath;

- (void)setupWithDict:(NSDictionary *)dict;
- (NSDictionary *)dictionary;

+ (HouseData *)dummyData;

@end

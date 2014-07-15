//
//  RenterData.h
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RenterData : NSObject

@property (nonatomic) long long cost;
@property (nonatomic) double duration;
@property (nonatomic) double timeDue;
@property (nonatomic) int count;

+ (RenterData *)dummyData;
- (NSDictionary *)dictionary;
- (RenterData *)initWithDict:(NSDictionary *)dict;

@end

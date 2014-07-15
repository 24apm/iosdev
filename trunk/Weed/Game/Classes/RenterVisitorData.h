//
//  RenterVisitorData.h
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VisitorData.h"
#import "RenterData.h"

@interface RenterVisitorData : VisitorData

@property (strong, nonatomic) RenterData *renterData;

+ (RenterVisitorData *)dummyData;

@end

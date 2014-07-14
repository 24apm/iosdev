//
//  RealEstateVisitorData.h
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VisitorData.h"
#import "HouseData.h"

@interface RealEstateVisitorData : VisitorData

@property (strong, nonatomic) HouseData *houseData;

@end

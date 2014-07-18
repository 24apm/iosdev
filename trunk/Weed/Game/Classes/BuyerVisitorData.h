//
//  BuyerVisitorData.h
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VisitorData.h"
#import "HouseData.h"

@interface BuyerVisitorData : VisitorData

@property (strong, nonatomic) HouseData *houseData;
@property (nonatomic) double priceModifier;

+ (BuyerVisitorData *)dummyData;
- (int)buyerPrice;

@end

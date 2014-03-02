//
//  NumberGameIAPHelper.h
//  NumberGame
//
//  Created by MacCoder on 3/1/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "IAPHelper.h"

@interface NumberGameIAPHelper : IAPHelper

@property (strong, nonatomic) NSArray *products;

+ (NumberGameIAPHelper *)sharedInstance;
- (void)loadProduct;

@end

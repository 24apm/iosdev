//
//  NumberGameIAPHelper.h
//  NumberGame
//
//  Created by MacCoder on 3/1/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "IAPHelper.h"

#define IAP_UNLOCK_ANSWER @"com.jeffrwan.whatstheanswer.answer"

@interface NumberGameIAPHelper : IAPHelper

@property (strong, nonatomic) NSArray *products;

+ (NumberGameIAPHelper *)sharedInstance;
- (void)loadProduct;

@end

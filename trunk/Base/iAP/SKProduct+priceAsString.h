//
//  SKProduct+priceAsString.h
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface SKProduct (priceAsString)

@property (nonatomic, readonly) NSString *priceAsString;

@end

//
//  NumberGameIAPHelper.m
//  NumberGame
//
//  Created by MacCoder on 3/1/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "NumberGameIAPHelper.h"

@interface NumberGameIAPHelper()

@end

@implementation NumberGameIAPHelper

+ (NumberGameIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static NumberGameIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      IAP_UNLOCK_ANSWER,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    
    return sharedInstance;
}

- (void)loadProduct {
    [[NumberGameIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            self.products = products;
        }
    }];
}

@end

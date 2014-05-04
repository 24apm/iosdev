//
//  CoinIAPHelper.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CoinIAPHelper.h"

@implementation CoinIAPHelper

+ (CoinIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static CoinIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      COIN_IAP_TIER_1,
                                      COIN_IAP_TIER_2,
                                      COIN_IAP_TIER_3,
                                      COIN_IAP_TIER_4,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

- (void)loadProduct {
    [[CoinIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            self.products = products;
            
            NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
            for (SKProduct *product in products) {
                [tempDictionary setObject:product forKey:product.productIdentifier];
            }
            self.productDictionary = [NSDictionary dictionaryWithDictionary:tempDictionary];
        }
    }];
}

- (SKProduct *)productForType:(CostTierType)type {
    SKProduct *skProduct = nil;
    switch (type) {
        case CostTierType1:
            skProduct = [[CoinIAPHelper sharedInstance].productDictionary objectForKey:COIN_IAP_TIER_1];
            break;
        case CostTierType2:
            skProduct = [[CoinIAPHelper sharedInstance].productDictionary objectForKey:COIN_IAP_TIER_2];
            break;
        case CostTierType3:
            skProduct = [[CoinIAPHelper sharedInstance].productDictionary objectForKey:COIN_IAP_TIER_3];
            break;
        case CostTierType4:
            skProduct = [[CoinIAPHelper sharedInstance].productDictionary objectForKey:COIN_IAP_TIER_4];
            break;
        default:
            break;
    }
    return skProduct;
}

- (int)valueForProductId:(NSString *)productId {
    int coin = 0;
    if ([productId isEqualToString:COIN_IAP_TIER_1]) {
        coin = 10;
    } else if ([productId isEqualToString:COIN_IAP_TIER_2]) {
        coin = 50;
    } else if ([productId isEqualToString:COIN_IAP_TIER_3]) {
        coin = 200;
    } else if ([productId isEqualToString:COIN_IAP_TIER_4]) {
        coin = 1000;
    }
    return coin;
}

@end

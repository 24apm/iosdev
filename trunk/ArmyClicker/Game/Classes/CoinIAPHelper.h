//
//  CoinIAPHelper.h
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "IAPHelper.h"
#import "SKProduct+priceAsString.h"


typedef enum {
    CostTierType1,
    CostTierType2,
    CostTierType3,
    CostTierType4
} CostTierType;

#define COIN_IAP_TIER_1 @"com.jeffrwan.20485x5Blitz.tier1coin"
#define COIN_IAP_TIER_2 @"com.jeffrwan.20485x5Blitz.tier2coin"
#define COIN_IAP_TIER_3 @"com.jeffrwan.20485x5Blitz.tier3coins"
#define COIN_IAP_TIER_4 @"com.jeffrwan.20485x5Blitz.tier4coin"

@interface CoinIAPHelper : IAPHelper

@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSDictionary *productDictionary;
@property (readonly, nonatomic) BOOL hasLoaded;

+ (CoinIAPHelper *)sharedInstance;
- (void)loadProduct;
- (SKProduct *)productForType:(CostTierType)type ;
- (int)valueForProductId:(NSString *)productId;
- (void)showCoinMenu;

@end

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
    IAPTypeFund,
    IAPTypeDouble,
    IAPTypeQuadruple,
    IAPTypeSuper
} IAPType;

#define POWER_UP_IAP_FUND @"com.jeffrwan.makeitswipe.fund"
#define POWER_UP_IAP_DOUBLE @"com.jeffrwan.makeitswipedouble"
#define POWER_UP_IAP_QUADPLE @"com.jeffrwan.makeitswipequadruple"
#define POWER_UP_IAP_SUPER @"com.jeffrwan.makeitswipesuper"

@interface CoinIAPHelper : IAPHelper

@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSDictionary *productDictionary;
@property (readonly, nonatomic) BOOL hasLoaded;

+ (CoinIAPHelper *)sharedInstance;
- (void)loadProduct;
- (SKProduct *)productForType:(IAPType)type ;
- (void)showCoinMenu;

@end

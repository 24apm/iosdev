//
//  CoinIAPHelper.h
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "IAPHelper.h"
#import "SKProduct+priceAsString.h"
#import "GameConstants.h"

#define IAP_ITEM_LOADED_NOTIFICATION @"IAP_ITEM_LOADED_NOTIFICATION"

typedef enum {
    IAPTypeFund,
    IAPTypeDouble,
    IAPTypeQuadruple,
    IAPTypeSuper
} IAPType;

@interface CoinIAPHelper : IAPHelper

@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSDictionary *productDictionary;
@property (readonly, nonatomic) BOOL hasLoaded;

+ (NSMutableDictionary *)iAPDictionary;

+ (CoinIAPHelper *)sharedInstance;
- (void)loadProduct;
- (SKProduct *)productForType:(IAPType)type ;
- (void)showCoinMenu;

@end

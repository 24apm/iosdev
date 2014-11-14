//
//  CoinIAPHelper.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CoinIAPHelper.h"
#import "CoinMenuView.h"
#import "ErrorDialogView.h"
#import "TrackUtils.h"
#import "UserData.h"

@interface CoinIAPHelper()

@property (nonatomic) BOOL loaded;
@property (nonatomic, strong) NSTimer *loadingTimer;

@end

@implementation CoinIAPHelper

- (void)showCoinMenu {
    if ([CoinIAPHelper sharedInstance].hasLoaded) {
        [[[CoinMenuView alloc] init] show];
    } else {
        [[[ErrorDialogView alloc] init] show];
    }
}

+ (CoinIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static CoinIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      IAP_TIER_1,
                                      IAP_TIER_2,
                                      IAP_TIER_3,
                                      IAP_TIER_4,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    self = [super initWithProductIdentifiers:productIdentifiers];
    if (self) {
        // add notification
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applyPowerUp:) name:APPLY_TRANSACTION_EFFECT_NOTIFICATION object:nil];
    }
    return self;
}

- (void)loadProduct {
    self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:30.f target:self selector:@selector(_loadProduct) userInfo:nil repeats:YES];
    [self _loadProduct];
}

- (void)_loadProduct {
    [[CoinIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            self.products = products;
            
            NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
            for (SKProduct *product in products) {
                [tempDictionary setObject:product forKey:product.productIdentifier];
            }
            self.productDictionary = [NSDictionary dictionaryWithDictionary:tempDictionary];
            self.loaded = YES;
            [self.loadingTimer invalidate], self.loadingTimer = nil;
            [[NSNotificationCenter defaultCenter]postNotificationName:IAP_ITEM_LOADED_NOTIFICATION object:nil];
        }
    }];
}

- (BOOL)hasLoaded {
    return self.loaded;
}

- (SKProduct *)productForType:(IAPType)type {
    SKProduct *skProduct = nil;
    switch (type) {
        case IAPTypeFund:
            skProduct = [[CoinIAPHelper sharedInstance].productDictionary objectForKey:IAP_TIER_1];
            break;
        case IAPTypeDouble:
            skProduct = [[CoinIAPHelper sharedInstance].productDictionary objectForKey:IAP_TIER_2];
            break;
        case IAPTypeQuadruple:
            skProduct = [[CoinIAPHelper sharedInstance].productDictionary objectForKey:IAP_TIER_3];
            break;
        case IAPTypeSuper:
            skProduct = [[CoinIAPHelper sharedInstance].productDictionary objectForKey:IAP_TIER_4];
            break;
        default:
            break;
    }
    return skProduct;
}

+ (NSMutableDictionary *)iAPDictionary {
    static NSMutableDictionary *iAPDictionary;
    if (!iAPDictionary) {
        iAPDictionary = [NSMutableDictionary dictionary];
        [iAPDictionary setObject:@(100) forKey:IAP_TIER_1];
        [iAPDictionary setObject:@(750) forKey:IAP_TIER_2];
        [iAPDictionary setObject:@(4000) forKey:IAP_TIER_3];
        [iAPDictionary setObject:@(10000) forKey:IAP_TIER_4];
    }
    return iAPDictionary;
}
//1 ->     2   +   0%      -> 2    *   50 = 100
// 5 ->     10  +   50%     -> 15   *   50 = 750
// 20 ->    40  +   100%    -> 80   *   50 = 4000
// 50 ->    100 +   200%    -> 200  *   50 = 10000

- (void)applyPowerUp:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    [[NSNotificationCenter defaultCenter]postNotificationName:BUYING_PRODUCT_ENDED_NOTIFICATION object:nil];
    if ([productIdentifier isEqualToString:IAP_TIER_1]) {
        [TrackUtils trackAction:@"Tier 1" label:@"End"];
        [[UserData instance] incrementCoin:[[[CoinIAPHelper iAPDictionary] objectForKey:IAP_TIER_1] integerValue]];
        
    } else if ([productIdentifier isEqualToString:IAP_TIER_2]) {
        [TrackUtils trackAction:@"Tier 2" label:@"End"];
        [[UserData instance] incrementCoin:[[[CoinIAPHelper iAPDictionary] objectForKey:IAP_TIER_2] integerValue]];
        
    } else if ([productIdentifier isEqualToString:IAP_TIER_3]) {
        [TrackUtils trackAction:@"Tier 3" label:@"End"];
        [[UserData instance] incrementCoin:[[[CoinIAPHelper iAPDictionary] objectForKey:IAP_TIER_3] integerValue]];
        
    } else if ([productIdentifier isEqualToString:IAP_TIER_4]) {
        [TrackUtils trackAction:@"Tier 4" label:@"End"];
        [[UserData instance] incrementCoin:[[[CoinIAPHelper iAPDictionary] objectForKey:IAP_TIER_4] integerValue]];
    }
}

@end

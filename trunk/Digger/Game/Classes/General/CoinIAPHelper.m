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
        //[[[CoinMenuView alloc] init] show];
    } else {
        [[[ErrorDialogView alloc] init] show];
    }
}

+ (CoinIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static CoinIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      POWER_UP_IAP_FUND,
                                      POWER_UP_IAP_DOUBLE,
                                      POWER_UP_IAP_QUADPLE,
                                      POWER_UP_IAP_SUPER,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

- (void)loadProduct {
    [self notificationSetUp];
    self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:30.f target:self selector:@selector(_loadProduct) userInfo:nil repeats:YES];
    [self _loadProduct];
}

- (void)notificationSetUp {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buyingProduct:) name:IAP_ITEM_PRESSED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applyPowerUp:) name:BUYING_PRODUCT_SUCCESSFUL_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(boughtProduct:) name:IAPHelperProductPurchasedNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productFailed:) name:IAPHelperProductFailedNotification object:nil];
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
            skProduct = [[CoinIAPHelper sharedInstance].productDictionary objectForKey:POWER_UP_IAP_FUND];
            break;
        case IAPTypeDouble:
            skProduct = [[CoinIAPHelper sharedInstance].productDictionary objectForKey:POWER_UP_IAP_DOUBLE];
            break;
        case IAPTypeQuadruple:
            skProduct = [[CoinIAPHelper sharedInstance].productDictionary objectForKey:POWER_UP_IAP_QUADPLE];
            break;
        case IAPTypeSuper:
            skProduct = [[CoinIAPHelper sharedInstance].productDictionary objectForKey:POWER_UP_IAP_SUPER];
            break;
        default:
            break;
    }
    return skProduct;
}

- (void)buyingProduct:(NSNotification *)notification {
    [TrackUtils trackAction:@"buyingProduct" label:@""];
    CoinView * coinView = notification.object;
    [[CoinIAPHelper sharedInstance] buyProduct:coinView.product];
}

- (void)boughtProduct:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    if (productIdentifier) {
        [TrackUtils trackAction:@"buyingProductSuccess" label:@""];
        [[NSNotificationCenter defaultCenter]postNotificationName:BUYING_PRODUCT_SUCCESSFUL_NOTIFICATION object:productIdentifier];
    }
}

- (void)productFailed:(NSNotification *)notification {
    [TrackUtils trackAction:@"buyingProductFail" label:@""];
    [[NSNotificationCenter defaultCenter]postNotificationName:BUYING_PRODUCT_ENDED_NOTIFICATION object:nil];
}

- (void)applyPowerUp:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    [[NSNotificationCenter defaultCenter]postNotificationName:BUYING_PRODUCT_ENDED_NOTIFICATION object:nil];
    if ([productIdentifier isEqualToString:POWER_UP_IAP_FUND]) {
        [TrackUtils trackAction:@"+5,000" label:@"End"];
        [[UserData instance] incrementCoin:5000];
        
    } else if ([productIdentifier isEqualToString:POWER_UP_IAP_DOUBLE]) {
        [TrackUtils trackAction:@"+20,000" label:@"End"];
        [[UserData instance] incrementCoin:20000];
        
    } else if ([productIdentifier isEqualToString:POWER_UP_IAP_QUADPLE]) {
        [TrackUtils trackAction:@"+100,000" label:@"End"];
        [[UserData instance] incrementCoin:100000];
        
    } else if ([productIdentifier isEqualToString:POWER_UP_IAP_SUPER]) {
        [TrackUtils trackAction:@"+1,000,000" label:@"End"];
        [[UserData instance] incrementCoin:10000000];
    }
}

@end

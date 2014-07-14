//
//  CoinMenuView.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CoinMenuView.h"

@implementation CoinMenuView

+ (CoinMenuView *)instance {
    static CoinMenuView *instance = nil;
    if (!instance) {
        instance = [[CoinMenuView alloc] init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productFailed:) name:IAPHelperProductFailedNotification object:nil];
    }
    return instance;
}

- (void)buyingProduct:(NSNotification *)notification {
    self.userInteractionEnabled = NO;
    [TrackUtils trackAction:@"buyingProduct" label:@""];
    CoinView * coinView = notification.object;
    [[CoinIAPHelper sharedInstance] buyProduct:coinView.product];
}

- (void)productPurchased:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    if (productIdentifier) {
        // Unlock answer
        self.userInteractionEnabled = YES;
        [TrackUtils trackAction:@"buyingProductSuccess" label:@""];
        [[NSNotificationCenter defaultCenter]postNotificationName:BUYING_PRODUCT_SUCCESSFUL_NOTIFICATION object:self];
        //[UserData instance].currentCoin += [[CoinIAPHelper sharedInstance] valueForProductId:productIdentifier];
        //[[UserData instance] saveUserCoin];
        [self dismissed:self];
    }
}

- (void)productFailed:(NSNotification *)notification {
    [TrackUtils trackAction:@"buyingProductFail" label:@""];
    self.userInteractionEnabled = YES;
}

- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:sender];
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [TrackUtils trackAction:@"buyingProductBackPressed" label:@""];
    [self dismissed:self];
}
@end

//
//  CoinMenuView.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CoinMenuView.h"
#import "UserData.h"
#import "MessageDialogView.h"
#import "CoinIAPHelper.h"

@implementation CoinMenuView

+ (CoinMenuView *)instance {
    static CoinMenuView *instance = nil;
    if (!instance) {
        instance = [[CoinMenuView alloc] init];
    }
    return instance;
}

- (void)show{
    [super show];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buyingProduct:) name:PURCHASE_BUTTON_TAPPED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productFailed:) name:IAPHelperProductFailedNotification object:nil];
    for (NSInteger i = 0; i < self.coinViewCollection.count; i++) {
        [[self.coinViewCollection objectAtIndex:i] setupProduct:[[CoinIAPHelper sharedInstance] productForType:i]];
    }
}

- (void)productFailed:(NSNotification *)notification {
    SKPaymentTransaction *transaction = notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [[[MessageDialogView alloc] initWithHeaderText:@"Uh Oh!" bodyText:transaction.error.localizedDescription] show];
    }
    [self enableButtons:YES];
    [TrackUtils trackAction:@"buyingProductFail" label:@""];
    [[NSNotificationCenter defaultCenter]postNotificationName:BUYING_PRODUCT_ENDED_NOTIFICATION object:nil];
}

- (void)buyingProduct:(NSNotification *)notification {
    [self enableButtons:NO];
    [TrackUtils trackAction:@"buyingProduct" label:@""];
    CoinView * coinView = notification.object;
    [[CoinIAPHelper sharedInstance] buyProduct:coinView.product];
}

- (void)productPurchased:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    if (productIdentifier) {
        // Unlock answer
        [self enableButtons:YES];
        [TrackUtils trackAction:@"buyingProductSuccess" label:@""];
        [[NSNotificationCenter defaultCenter]postNotificationName:BUYING_PRODUCT_SUCCESSFUL_NOTIFICATION object:self];
        [[[MessageDialogView alloc] initWithHeaderText:@"Yay!" bodyText:[NSString stringWithFormat:@"You bought %d coins!", [[[CoinIAPHelper iAPDictionary] objectForKey:productIdentifier] integerValue]]] show];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:APPLY_TRANSACTION_NOTIFICATION object:productIdentifier];
        [self dismissed:self];
    }
}

- (void)enableButtons:(BOOL)userInteractionEnabled {
    for (CoinView *coinView in self.coinViewCollection) {
        coinView.userInteractionEnabled = userInteractionEnabled;
    }
}

- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:BUY_COIN_VIEW_DISMISS_NOTIFICATION object:nil];
    [super dismissed:sender];
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [TrackUtils trackAction:@"buyingProductBackPressed" label:@""];
    [self dismissed:self];
}
@end

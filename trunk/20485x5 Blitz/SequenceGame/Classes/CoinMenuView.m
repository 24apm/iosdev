//
//  CoinMenuView.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CoinMenuView.h"

@implementation CoinMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)show {
    [super show];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buyingProduct:) name:PURCHASE_BUTTON_TAPPED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productFailed:) name:IAPHelperProductFailedNotification object:nil];
    for (int i = CostTierType1; i <= CostTierType4; i++) {
        [[self.coinViewCollection objectAtIndex:i] setupProduct:[[CoinIAPHelper sharedInstance] productForType:i]];
    }
}
 
- (void)buyingProduct:(NSNotification *)notification {
    self.userInteractionEnabled = NO;
    CoinView * coinView = notification.object;
    [[CoinIAPHelper sharedInstance] buyProduct:coinView.product];
}

- (void)productPurchased:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    if (productIdentifier) {
        // Unlock answer
        self.userInteractionEnabled = YES;
        [UserData instance].currentCoin += [[CoinIAPHelper sharedInstance] valueForProductId:productIdentifier];
        [[UserData instance] saveUserCoin];
    }
}

- (void)productFailed:(NSNotification *)notification {
    self.userInteractionEnabled = YES;
}

- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:sender];
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissed:self];
}
@end

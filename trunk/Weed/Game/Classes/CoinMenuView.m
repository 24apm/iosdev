//
//  CoinMenuView.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CoinMenuView.h"
#import "UserData.h"

@implementation CoinMenuView

+ (CoinMenuView *)instance {
    static CoinMenuView *instance = nil;
    if (!instance) {
        instance = [[CoinMenuView alloc] init];
    }
    return instance;
}

- (void)show{

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



- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:sender];
}

- (void)applyPowerUp:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    
    if ([productIdentifier isEqualToString:POWER_UP_IAP_FUND]) {
        [TrackUtils trackAction:@"+5000" label:@"End"];
        [[UserData instance] incrementCoin:5000];
        
    } else if ([productIdentifier isEqualToString:POWER_UP_IAP_DOUBLE]) {
        [TrackUtils trackAction:@"+20000" label:@"End"];
        [[UserData instance] incrementCoin:20000];
        
    } else if ([productIdentifier isEqualToString:POWER_UP_IAP_QUADPLE]) {
        [TrackUtils trackAction:@"+50000" label:@"End"];
        [[UserData instance] incrementCoin:80000];
        
    } else if ([productIdentifier isEqualToString:POWER_UP_IAP_SUPER]) {
        [TrackUtils trackAction:@"+1000000" label:@"End"];
        [[UserData instance] incrementCoin:1000000];
        
    }
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [TrackUtils trackAction:@"buyingProductBackPressed" label:@""];
    [self dismissed:self];
}
@end

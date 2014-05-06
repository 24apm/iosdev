//
//  CoinView.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CoinView.h"

@implementation CoinView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setupProduct:(SKProduct *)product {
    self.product = product;
    [self refresh];
}

- (void)refresh {
    self.coinLabel.text = [NSString stringWithFormat:@"%d",[[CoinIAPHelper sharedInstance] valueForProductId:self.product.productIdentifier]];
    self.coinLabel.strokeColor = [UIColor blackColor];
    self.coinLabel.strokeSize = 2.f * IPAD_SCALE;
    self.costLabel.strokeColor = [UIColor colorWithRed:.5f green:.5f blue:0.f alpha:1.f];
    self.costLabel.strokeSize = 1.f * IPAD_SCALE;
    self.costLabel.text = self.product.priceAsString;
    [self setupImage];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:PURCHASE_BUTTON_TAPPED object:self];
}

- (void)setupImage {
    if ([self.product.productIdentifier isEqualToString:COIN_IAP_TIER_1]) {
        self.imageView.image = [UIImage imageNamed:@"tier1Coin"];
    } else if ([self.product.productIdentifier isEqualToString:COIN_IAP_TIER_2]) {
        self.imageView.image = [UIImage imageNamed:@"tier2coin"];
    } else if ([self.product.productIdentifier isEqualToString:COIN_IAP_TIER_3]) {
        self.imageView.image = [UIImage imageNamed:@"tier3coin"];
    } else  if ([self.product.productIdentifier isEqualToString:COIN_IAP_TIER_4]) {
        self.imageView.image = [UIImage imageNamed:@"tier4coin"];
    }
}

@end

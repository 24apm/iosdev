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
    self.costLabel.text = self.product.priceAsString;
}

- (IBAction)buttonPressed:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:PURCHASE_BUTTON_TAPPED object:self];
}

@end

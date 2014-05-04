//
//  CoinView.h
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "CoinIAPHelper.h"
#define PURCHASE_BUTTON_TAPPED @"PURCHASE_BUTTON_TAPPED"

@interface CoinView : XibView

@property (strong, nonatomic) IBOutlet UILabel *costLabel;
@property (nonatomic) SKProduct *product;

- (void)setupProduct:(SKProduct *)product;

@end

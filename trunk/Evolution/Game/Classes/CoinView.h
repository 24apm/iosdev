//
//  CoinView.h
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "CoinIAPHelper.h"
#import "THLabel.h"
#import "GameConstants.h"
#define PURCHASE_BUTTON_TAPPED @"PURCHASE_BUTTON_TAPPED"

@interface CoinView : XibView

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet THLabel *costLabel;
@property (nonatomic) SKProduct *product;
@property (strong, nonatomic) IBOutlet THLabel *coinLabel;

- (void)setupProduct:(SKProduct *)product;

@end

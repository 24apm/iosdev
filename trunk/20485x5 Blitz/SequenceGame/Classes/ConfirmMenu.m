//
//  ConfirmMenu.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ConfirmMenu.h"
#import "CoinMenuView.h"

@implementation ConfirmMenu


- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

//+ (void)show {
//    
//    [[[ConfirmMenu alloc] init] show];
//    
//}

- (void)show:(ButtonView *)buttonView {
    [super show];
    self.buttonView = buttonView;
    self.itemCost.text = [NSString stringWithFormat:@"%d", buttonView.priceCheck];
    self.currentCoin.text = [NSString stringWithFormat:@"%d", [UserData instance].currentCoin];
    self.afterPay = [UserData instance].currentCoin - buttonView.priceCheck;
    self.result.text = [NSString stringWithFormat:@"%d", self.afterPay];
}

- (void)showCoin {
    [super show];
//    self.itemCost.text = [NSString stringWithFormat:@"%d", buttonView.priceCheck];
//    self.currentCoin.text = [NSString stringWithFormat:@"%d", [UserData instance].currentCoin];
//    self.afterPay = [UserData instance].currentCoin - buttonView.priceCheck;
//    self.result.text = [NSString stringWithFormat:@"%d", self.afterPay];
}

- (IBAction)confirmButtonPressed:(UIButton *)sender {
    if (self.afterPay >= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BUY_POWER_CONFIRM_BUTTON_PRESSED_NOTIFICATION object:self.buttonView];
        [self dismissView];
    } else {
        [[[CoinMenuView alloc] init] show];
    }
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissView];
}

- (void)dismissView {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:self];
}

@end

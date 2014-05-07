//
//  ConfirmMenu.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ConfirmMenu.h"
#import "CoinMenuView.h"
#import "Utils.h"

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
    self.itemCost.strokeColor = [UIColor blackColor];
    self.itemCost.strokeSize = 2.f * IPAD_SCALE;
    self.buttonView = buttonView;
    self.itemCost.text = [Utils formatWithFreeCost:buttonView.priceCheck];
    self.currentCoin.text = [NSString stringWithFormat:@"%d", [UserData instance].currentCoin];
    self.afterPay = [UserData instance].currentCoin - buttonView.priceCheck;
    self.result.text = [NSString stringWithFormat:@"%d", self.afterPay];
    [self updateImgViews:(buttonView.type)];
}

- (void)updateImgViews:(ButtonViewType)type {
    switch (type) {
        case ButtonViewTypeShuffle:
            self.applyingImage.image = [UIImage imageNamed:@"applyingshuffle"];
            self.afterImage.image = [UIImage imageNamed:@"aftershuffle"];
            break;
        case ButtonViewTypeBomb2:
            self.applyingImage.image = [UIImage imageNamed:@"applyingbomb2"];
            self.afterImage.image = [UIImage imageNamed:@"afterbomb2"];
            break;
        case ButtonViewTypeBomb4:
            self.applyingImage.image = [UIImage imageNamed:@"applyingbomb4"];
            self.afterImage.image = [UIImage imageNamed:@"afterbomb4"];
            break;
        case ButtonViewTypeLostShuffle:
            self.applyingImage.image = [UIImage imageNamed:@"applyingshuffle"];
            self.afterImage.image = [UIImage imageNamed:@"aftershuffle"];
            break;
        case ButtonViewTypeLostBomb2:
            self.applyingImage.image = [UIImage imageNamed:@"applyingbomb2"];
            self.afterImage.image = [UIImage imageNamed:@"afterbomb2"];
            break;
        case ButtonViewTypeLostBomb4:
            self.applyingImage.image = [UIImage imageNamed:@"applyingbomb4"];
            self.afterImage.image = [UIImage imageNamed:@"afterbomb4"];
            break;
            
        default:
            break;
    }
}

- (void)showCoin {
    [super show];
}

- (IBAction)confirmButtonPressed:(UIButton *)sender {
    [TrackUtils trackAction:@"confirmConfirmButtonPressed" label:@""];
    if (self.afterPay >= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BUY_POWER_CONFIRM_BUTTON_PRESSED_NOTIFICATION object:self.buttonView];
    } else {
        [[CoinIAPHelper sharedInstance] showCoinMenu];
    }
        [self dismissed:self];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [TrackUtils trackAction:@"confirmCancelButtonPressed" label:@""];
    [self dismissed:self];
}


@end

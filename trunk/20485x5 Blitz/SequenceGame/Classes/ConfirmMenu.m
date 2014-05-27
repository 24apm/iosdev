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
#import "PurchaseManager.h"

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
    self.confirmButton.layer.cornerRadius = 8.f * IPAD_SCALE;
    self.itemCost.strokeColor = [UIColor blackColor];
    self.itemCost.strokeSize = 2.f * IPAD_SCALE;
    self.buttonView = buttonView;
    self.itemCost.text = [Utils formatWithFreeCost:buttonView.priceCheck];
    [self updateImgViews:(buttonView.type)];
}

- (void)updateImgViews:(ButtonViewType)type {
    switch (type) {
        case ButtonViewTypeShuffle:
            self.leftImage.image = [UIImage imageNamed:@"button_powerup_bomb_shuffle.png"];
            self.rightImage.image = [UIImage imageNamed:@"button_powerup_bomb_shuffle.png"];
            self.applyingImage.image = [UIImage imageNamed:@"applyingshuffle"];
            self.afterImage.image = [UIImage imageNamed:@"aftershuffle"];
            self.contentView.backgroundColor = [UIColor colorWithRed:.2f green:.5f blue:.2f alpha:.8f];
            break;
        case ButtonViewTypeBomb2:
            self.leftImage.image = [UIImage imageNamed:@"button_powerup_bomb2"];
            self.rightImage.image = [UIImage imageNamed:@"button_powerup_bomb2"];
            self.applyingImage.image = [UIImage imageNamed:@"applyingbomb2"];
            self.afterImage.image = [UIImage imageNamed:@"afterbomb2"];
            self.contentView.backgroundColor = [UIColor colorWithRed:.2f green:.2f blue:.5f alpha:.8f];
            break;
        case ButtonViewTypeBomb4:
            self.leftImage.image = [UIImage imageNamed:@"button_powerup_bomb4"];
            self.rightImage.image = [UIImage imageNamed:@"button_powerup_bomb4"];
            self.applyingImage.image = [UIImage imageNamed:@"applyingbomb4"];
            self.afterImage.image = [UIImage imageNamed:@"afterbomb4"];
            self.contentView.backgroundColor = [UIColor colorWithRed:.5f green:.2f blue:.2f alpha:.8f];
            break;
        case ButtonViewTypeLostShuffle:
            self.leftImage.image = [UIImage imageNamed:@"button_powerup_bomb_shuffle.png"];
            self.rightImage.image = [UIImage imageNamed:@"button_powerup_bomb_shuffle.png"];
            self.applyingImage.image = [UIImage imageNamed:@"applyingshuffle"];
            self.afterImage.image = [UIImage imageNamed:@"aftershuffle"];
            self.contentView.backgroundColor = [UIColor colorWithRed:.2f green:.5f blue:.2f alpha:.8f];
            break;
        case ButtonViewTypeLostBomb2:
            self.leftImage.image = [UIImage imageNamed:@"button_powerup_bomb2"];
            self.rightImage.image = [UIImage imageNamed:@"button_powerup_bomb2"];
            self.applyingImage.image = [UIImage imageNamed:@"applyingbomb2"];
            self.afterImage.image = [UIImage imageNamed:@"afterbomb2"];
            self.contentView.backgroundColor = [UIColor colorWithRed:.2f green:.2f blue:.5f alpha:.8f];
            break;
        case ButtonViewTypeLostBomb4:
            self.leftImage.image = [UIImage imageNamed:@"button_powerup_bomb4"];
            self.rightImage.image = [UIImage imageNamed:@"button_powerup_bomb4"];
            self.applyingImage.image = [UIImage imageNamed:@"applyingbomb4"];
            self.afterImage.image = [UIImage imageNamed:@"afterbomb4"];
            self.contentView.backgroundColor = [UIColor colorWithRed:.5f green:.2f blue:.2f alpha:.8f];
            break;
            
        default:
            break;
    }
}

- (void)showCoin {
    [super show];
}

- (IBAction)confirmButtonPressed:(UIButton *)sender {
    [TrackUtils trackAction:[NSString stringWithFormat:@"%@%d", @"confirmConfirmButtonPressedType_", self.buttonView.powerType] label:[Utils formatWithFreeCost:self.buttonView.priceCheck]];
    if ([[PurchaseManager instance] purchasePowerUp:self.buttonView.powerType]){
        [[NSNotificationCenter defaultCenter] postNotificationName:BUY_POWER_CONFIRM_BUTTON_PRESSED_NOTIFICATION object:self.buttonView];
    }
    [self dismissed:self];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [TrackUtils trackAction:@"confirmCancelButtonPressed" label:@""];
    [self dismissed:self];
}


@end

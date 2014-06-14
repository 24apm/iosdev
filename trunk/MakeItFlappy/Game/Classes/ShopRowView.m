//
//  ShopRowView.m
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ShopRowView.h"
#import "UserData.h"
#import "ShopItem.h"
#import "GameConstants.h"
#import "Utils.h"
#import "AnimatedLabel.h"

@implementation ShopRowView

- (void)setupWithItem:(ShopItem *)item {
    self.item = item;
    self.label.text = item.name;
    self.costLabel.hidden = NO;
    self.costButton.hidden = NO;
    self.costButton.titleLabel.minimumScaleFactor = 0.5f;
    self.costButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.descriptionLabel.text = [item formatDescriptionWithValue:item.upgradeMultiplier];
    
    [self setUpPriceTag];
    
    self.itemMaxLevel = NO;
    NSMutableDictionary *typeDictionary = [[UserData instance].gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", item.type]];
    int itemLevel = [[typeDictionary objectForKey:item.itemId]intValue];
    self.levelLabel.text = [NSString stringWithFormat:@"%d", itemLevel];
    if (itemLevel >= LEVEL_CAP) {
        self.itemMaxLevel = YES;
        self.costLabel.text = @"MAXED";
        [self.costButton setTitle:@"MAXED" forState:UIControlStateNormal];
        self.overlayView.hidden = NO;
    } else {
        self.overlayView.hidden = YES;
    }
}
- (IBAction)buttonPressed:(UIButton *)sender {
    if (self.item.type == POWER_UP_TYPE_IAP) {

        [[NSNotificationCenter defaultCenter]postNotificationName:IAP_ITEM_PRESSED_NOTIFICATION object:self];
        
    } else {
        if (!self.itemMaxLevel && [UserData instance].currentScore >= self.cost) {
            [UserData instance].currentScore = [UserData instance].currentScore - self.cost;
            [[UserData instance] saveUserCoin];
            [[UserData instance] levelUpPower:self.item];
            [[NSNotificationCenter defaultCenter]postNotificationName:SHOP_BUTTON_PRESSED_NOTIFICATION object:self];
        }
    }
}


- (void)setUpPriceTag {
    if (self.item.type == POWER_UP_TYPE_IAP) {
        self.levelLabel.hidden = YES;
        self.levelImage.hidden = YES;
        [self.costButton setBackgroundImage:[UIImage imageNamed:@"btn_gold_up"] forState:UIControlStateNormal];
         self.iapType = [self lookUpTableForIAPWithRank];
        [self.costButton setTitle:[[CoinIAPHelper sharedInstance] productForType:self.iapType].priceAsString forState:UIControlStateNormal];
        self.cost = 0;
        self.imageView.image = [Utils imageNamed:[UIImage imageNamed:self.item.imagePath]
                                       withColor:[self.item tierColor:self.item.rank]
                                       blendMode:kCGBlendModeMultiply];
    } else {
        self.levelLabel.hidden = NO;
        self.levelImage.hidden = NO;
        [self.costButton setBackgroundImage:[UIImage imageNamed:@"btn_green_up"] forState:UIControlStateNormal];
        self.cost = [[ShopManager instance] priceForItemId:self.item.itemId type:self.item.type];
        self.imageView.image = [Utils imageNamed:[UIImage imageNamed:self.item.imagePath]
                                       withColor:[self.item tierColor:self.item.rank]
                                       blendMode:kCGBlendModeMultiply];
        NSString *costLabel = [Utils formatLongLongWithComma:self.cost];
        [self.costButton setTitle:costLabel forState:UIControlStateNormal];
    }
}

- (IAPType)lookUpTableForIAPWithRank {
    switch (self.item.rank) {
        case 4:
            self.product = [[CoinIAPHelper sharedInstance] productForType:IAPTypeFund];
            return IAPTypeFund;
            break;
        case 1:
            self.product = [[CoinIAPHelper sharedInstance] productForType:IAPTypeDouble];
            return IAPTypeDouble;
            break;
        case 2:
            self.product = [[CoinIAPHelper sharedInstance] productForType:IAPTypeQuadruple];
            return IAPTypeQuadruple;
            break;
        case 3:
            self.product = [[CoinIAPHelper sharedInstance] productForType:IAPTypeSuper];
            return IAPTypeSuper;
            break;
        default:
            break;
    }
    return 0;
}
@end

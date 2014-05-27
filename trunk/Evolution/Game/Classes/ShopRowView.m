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
            [[UserData instance] levelUpPower:self.item];
            [[NSNotificationCenter defaultCenter]postNotificationName:SHOP_BUTTON_PRESSED_NOTIFICATION object:nil];
        }
    }
}

- (void)setUpPriceTag {
    if (self.item.type == POWER_UP_TYPE_IAP) {
        IAPType currentType = [self lookUpTableForIAP];
        [self.costButton setTitle:[[CoinIAPHelper sharedInstance] productForType:currentType].priceAsString forState:UIControlStateNormal];
        self.cost = 0;
        self.imageView.image = [Utils imageNamed:[UIImage imageNamed:self.item.imagePath]
                                       withColor:[self.item tierColor:self.item.rank]
                                       blendMode:kCGBlendModeMultiply];
    } else {
        self.cost = [[ShopManager instance] priceForItemId:self.item.itemId type:self.item.type];
        self.imageView.image = [Utils imageNamed:[UIImage imageNamed:self.item.imagePath]
                                       withColor:[self.item tierColor:self.item.rank]
                                       blendMode:kCGBlendModeMultiply];
        [self.costButton setTitle:[NSString stringWithFormat:@"$%d", self.cost] forState:UIControlStateNormal];
    }
}

- (IAPType)lookUpTableForIAP {
    switch (self.item.rank) {
        case 4:
            return IAPTypeFund;
            break;
        case 3:
            return IAPTypeDouble;
            break;
        case 2:
            return IAPTypeQuadruple;
            break;
        case 5:
            return IAPTypeSuper;
            break;
        default:
            break;
    }
    return 0;
}
@end

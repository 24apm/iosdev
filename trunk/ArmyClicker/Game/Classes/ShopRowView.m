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
#import "ShopManager.h"
#import "GameConstants.h"

@implementation ShopRowView

- (void)setupWithItem:(ShopItem *)item {
    self.item = item;
    self.label.text = item.name;
    self.costLabel.hidden = NO;
    self.costButton.hidden = NO;
    self.descriptionLabel.text = item.description;
    self.cost = [[ShopManager instance] priceForItemId:item.itemId type:item.type];
    self.costLabel.text = [NSString stringWithFormat:@"$%d", self.cost];
    [self.costButton setTitle:[NSString stringWithFormat:@"$%d", self.cost] forState:UIControlStateNormal];
    self.imageView.image = [UIImage imageNamed:item.imagePath];
    self.itemMaxLevel = NO;
    self.overlayView.hidden = YES;
    NSMutableDictionary *typeDictionary = [[UserData instance].gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", item.type]];
    int itemLevel = [[typeDictionary objectForKey:item.itemId]intValue];
    self.levelLabel.text = [NSString stringWithFormat:@"%d", itemLevel];
    if (itemLevel >= LEVEL_CAP) {
        self.itemMaxLevel = YES;
        self.costLabel.text = @"MAXED";
        [self.costButton setTitle:@"MAXED" forState:UIControlStateNormal];
        self.overlayView.hidden = NO;
    }
}
- (IBAction)buttonPressed:(UIButton *)sender {
    if (!self.itemMaxLevel && [UserData instance].currentScore >= self.cost) {
        [UserData instance].currentScore = [UserData instance].currentScore - self.cost;
        [[UserData instance] levelUpPower:self.item];
        [[NSNotificationCenter defaultCenter]postNotificationName:SHOP_BUTTON_PRESSED_NOTIFICATION object:nil];
    }
    
    
}

@end

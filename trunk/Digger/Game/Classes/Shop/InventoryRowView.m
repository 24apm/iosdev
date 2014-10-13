//
//  ShopRowView.m
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "InventoryRowView.h"
#import "UserData.h"
#import "GameConstants.h"
#import "Utils.h"
#import "CoinIAPHelper.h"

@implementation InventoryRowView

- (void)setupWithItem:(InventoryRowItem *)item {
    self.item = item;
    self.label.text = item.name;
    self.descriptionLabel.text = item.descriptionLabel;
    self.levelLabel.text = [NSString stringWithFormat:@"%d", item.rank];
    self.imageView.image = [Utils imageNamed:[UIImage imageNamed:self.item.imagePath]
                                   withColor:[self.item tierColor:self.item.rank]
                                   blendMode:kCGBlendModeMultiply];
    self.rank = item.rank;
    if (self.item.state == KnapsackStateEmpty) {
        self.label.hidden = YES;
        self.levelLabel.hidden = YES;
        self.descriptionLabel.hidden = YES;
        self.imageView.hidden = YES;
        self.goButton.hidden = YES;
        self.levelImage.hidden = YES;
        self.overlayView.hidden = NO;
    } else {
        self.label.hidden = NO;
        self.levelLabel.hidden = NO;
        self.descriptionLabel.hidden = NO;
        self.imageView.hidden = NO;
        self.goButton.hidden = NO;
        self.levelImage.hidden = NO;
        self.overlayView.hidden = YES;
    }
    
    if (self.item.state == KnapsackStateOverWeight) {
        [self.rowButton setBackgroundColor:[UIColor redColor]];
    } else {
        [self.rowButton setBackgroundColor:[UIColor blueColor]];
    }
}
- (IBAction)buttonPressed:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:INVENTORY_ITEM_DROP_PRESSED_NOTIFICATION object:self.item];
}

@end

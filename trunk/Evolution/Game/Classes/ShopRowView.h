//
//  ShopRowView.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "ShopItem.h"
#import "ShopManager.h"
#import "CoinIAPHelper.h"

#define SHOP_BUTTON_PRESSED_NOTIFICATION @"SHOP_BUTTON_PRESSED_NOTIFICATION"
#define IAP_ITEM_PRESSED_NOTIFICATION @"IAP_ITEM_PRESSED_NOTIFICATION"

@interface ShopRowView : XibView

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) int cost;
@property (nonatomic) SKProduct *product;
@property (nonatomic, strong) ShopItem *item;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (nonatomic) BOOL itemMaxLevel;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UIButton *costButton;

- (void)setupWithItem:(ShopItem *)item;

@end

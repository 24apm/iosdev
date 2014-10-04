//
//  ShopRowView.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "ShopRowItem.h"
#import "TableManager.h"
#import "CoinIAPHelper.h"

@interface ShopRowView : XibView

@property (strong, nonatomic) IBOutlet UIImageView *levelImage;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) long long cost;
@property (nonatomic) SKProduct *product;
@property (nonatomic, strong) ShopRowItem *item;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (nonatomic) BOOL itemMaxLevel;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UIButton *costButton;
@property (nonatomic) IAPType iapType;

- (void)setupWithItem:(ShopRowItem *)item;

@end
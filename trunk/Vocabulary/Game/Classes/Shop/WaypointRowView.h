//
//  ShopRowView.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "WaypointRowItem.h"
#import "TableManager.h"
#import "CoinIAPHelper.h"

@interface WaypointRowView : XibView

@property (strong, nonatomic) IBOutlet UIImageView *levelImage;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) WaypointRowItem *item;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (nonatomic) NSUInteger rank;

- (void)setupWithItem:(WaypointRowItem *)item;

@end

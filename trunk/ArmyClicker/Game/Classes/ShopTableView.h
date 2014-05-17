//
//  ShopTableView.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "ShopManager.h"

#define SHOP_TABLE_VIEW_NOTIFICATION @"ShopTableViewDismissed"

@interface ShopTableView : XibView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) PowerUpType currentType;

- (void)show;
- (void)refresh;
- (void)setupWithItemIds:(NSArray *)items;
- (void)setupWithType:(PowerUpType)type;

@end

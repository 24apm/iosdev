//
//  ShopTableView.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "TableManager.h"
#define SHOP_TABLE_VIEW_NOTIFICATION @"ShopTableViewDismissed"

@interface ShopTableView : XibView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) TableType currentType;

- (void)showTable;
- (void)refresh;
- (void)setupWithItemIds:(NSArray *)items;
- (void)setupWithType:(TableType)type;
- (void)setupInventory;
- (void)closeTable;
- (void)refreshInventory;
@end

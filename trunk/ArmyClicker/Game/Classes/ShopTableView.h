//
//  ShopTableView.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface ShopTableView : XibView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)refresh;
- (void)setupWithItems:(NSArray *)items;

@end

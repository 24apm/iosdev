//
//  ShopTableView.m
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ShopRowView.h"
#import "ShopTableView.h"
#import "XibTableViewCell.h"

@interface ShopTableView()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic) CGRect cellFrame;

@end

@implementation ShopTableView

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    ShopRowView *t = [[ShopRowView alloc] init];
    self.cellFrame = t.frame;
    self.currentType = POWER_UP_TYPE_TAP;
}

- (void)setupWithItemIds:(NSArray *)items {
    self.items = items;
    [self refresh];
}

- (void)setupWithType:(PowerUpType)type {
    self.currentType = type;
    [self setupWithItemIds:[[ShopManager instance] arrayOfitemIdsFor:self.currentType]];
    [self refresh];
}

- (void)refresh {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopRowView"];
    if (!cell) {
        cell = [[XibTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopRowView" className:@"ShopRowView"];
    }
    ShopRowView *rowView = (ShopRowView *)cell.view;
    NSString *itemId = [self.items objectAtIndex:indexPath.row];
    ShopItem *shopItem = [[ShopManager instance] shopItemForItemId:itemId dictionary:self.currentType];
    [rowView setupWithItem:shopItem];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellFrame.size.height;
}



- (void)show {
    float yOffset = self.superview.height - self.height;
    [UIView animateWithDuration:0.3f animations:^ {
        self.y = yOffset;
    }];
}

- (IBAction)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOP_TABLE_VIEW_NOTIFICATION object:nil];
    float yOffset = self.superview.height;
    [UIView animateWithDuration:0.3f animations:^ {
        self.y = yOffset;
    }];
}

@end
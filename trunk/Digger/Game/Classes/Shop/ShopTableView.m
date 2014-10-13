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
#import "WaypointRowView.h"
#import "InventoryRowView.h"
#import "GameConstants.h"

@interface ShopTableView()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic) CGRect cellFrame;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

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
    self.currentType = TableTypeIAP;
}

- (void)setupWithItemIds:(NSArray *)items {
    self.items = items;
    [self refresh];
}

- (void)setupWithType:(TableType)type {
    self.currentType = type;
    [self setupWithItemIds:[[TableManager instance] arrayOfitemIdsFor:self.currentType]];
    [self refresh];
}

- (void)setupInventory {
    self.currentType = TableTypeInventory;
    [self setupWithItemIds:[[TableManager instance] arrayOfInventory]];
}

- (void)refreshInventory {
    self.currentType = TableTypeInventory;
    self.items = [[TableManager instance] arrayOfInventory];
    [self refreshRow];
}

- (void)refresh {
    [self.layer removeAllAnimations];
     [self.tableView reloadData];
}

- (void)refreshRow {
    [self.layer removeAllAnimations];
    /* Animate the table view reload */
    [UIView transitionWithView: self.tableView
                      duration: 0.35f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
         [self.tableView reloadData];
     }
                    completion: ^(BOOL isFinished)
     {
        [[NSNotificationCenter defaultCenter]postNotificationName:FINISH_ANIMATING_ROW_REFRESH_NOTIFICATION object:nil];
     }];
//    [UIView animateWithDuration:0.3f animations:^{
//        [self.tableView  reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
//    } completion:^(BOOL finished) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:FINISH_ANIMATING_ROW_REFRESH_NOTIFICATION object:nil];
//    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    XibTableViewCell *cell;
//    if (self.currentType == TableTypeWaypoint) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"WaypointRowView"];
//        if (!cell) {
//            cell = [[XibTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WaypointRowView" className:@"WaypointRowView"];
//        }
//        WaypointRowView *rowView = (WaypointRowView *)cell.view;
//        NSString *itemId = [self.items objectAtIndex:indexPath.row];
//        WaypointRowItem *shopItem = [[TableManager instance] waypointItemForItemId:itemId dictionary:self.currentType];
//        [rowView setupWithItem:shopItem];
//
//    } else if (self.currentType == TableTypeInventory) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"InventoryRowView"];
//        if (!cell) {
//            cell = [[XibTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InventoryRowView" className:@"InventoryRowView"];
//        }
//        InventoryRowView *rowView = (InventoryRowView *)cell.view;
//        NSString *itemId = [self.items objectAtIndex:indexPath.row];
//        InventoryRowItem *shopItem = [[TableManager instance] inventoryItemForItemId:itemId dictionary:self.currentType];
//        [rowView setupWithItem:shopItem];
//
//    } else if (self.currentType == TableTypeIAP) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"ShopRowView"];
//        if (!cell) {
//            cell = [[XibTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopRowView" className:@"ShopRowView"];
//        }
//        ShopRowView *rowView = (ShopRowView *)cell.view;
//        NSString *itemId = [self.items objectAtIndex:indexPath.row];
//        ShopRowItem *shopItem = [[TableManager instance] shopItemForItemId:itemId dictionary:self.currentType];
//        [rowView setupWithItem:shopItem];
//    }
//
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XibTableViewCell *cell;
    if (self.currentType == TableTypeWaypoint) {
        NSString *itemId = [self.items objectAtIndex:indexPath.row];
        WaypointRowItem *shopItem = [[TableManager instance] waypointItemForItemId:itemId dictionary:self.currentType];
        cell = [self setupCell:@"WaypointRowView" item:shopItem];
    } else if (self.currentType == TableTypeInventory) {
        NSString *itemId = [self.items objectAtIndex:indexPath.row];
        InventoryRowItem *shopItem = [[TableManager instance] inventoryItemForItemId:itemId dictionary:self.currentType];
        cell = [self setupCell:@"InventoryRowView" item:shopItem];
    } else if (self.currentType == TableTypeIAP) {
        NSString *itemId = [self.items objectAtIndex:indexPath.row];
        ShopRowItem *shopItem = [[TableManager instance] shopItemForItemId:itemId dictionary:self.currentType];
        cell = [self setupCell:@"ShopRowView" item:shopItem];
    }
    
    return cell;
}

- (XibTableViewCell *)setupCell:(NSString *)type item:(NSObject *)item {
    XibTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:type];
    if (!cell) {
        cell = [[XibTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type className:type];
    }
    UIView *rowView = cell.view;
    if ([rowView respondsToSelector:@selector(setupWithItem:)]) {
        [rowView performSelector:@selector(setupWithItem:) withObject:item];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellFrame.size.height;
}



- (void)showTable {
    float yOffset = self.superview.height - self.height;
    [UIView animateWithDuration:0.3f animations:^ {
        self.y = yOffset;
    }];
    //[[NSNotificationCenter defaultCenter] postNotificationName:SHOP_TABLE_VIEW_NOTIFICATION_OPEN object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideButton) name:UPGRADE_VIEW_OPEN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showButton) name:UPGRADE_VIEW_CLOSED_NOTIFICATION object:nil];
}

- (void)hideButton {
    self.closeButton.hidden = YES;
}

- (void)showButton {
    self.closeButton.hidden = NO;
}

- (IBAction)dismissed:(id)sender {
    [self closeTable];
}

- (void)closeTable {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOP_TABLE_VIEW_NOTIFICATION_CLOSE object:nil];
    float yOffset = self.superview.height;
    [UIView animateWithDuration:0.3f animations:^ {
        self.y = yOffset;
    }];
}

@end

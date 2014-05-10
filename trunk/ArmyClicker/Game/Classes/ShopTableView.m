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
}

- (void)setupWithItems:(NSArray *)items {
    self.items = items;
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
    NSString *item = [self.items objectAtIndex:indexPath.row];
    [rowView setupWithItem:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellFrame.size.height;
}

- (IBAction)dismissed:(id)sender {
    float yOffset = self.superview.height;
    [UIView animateWithDuration:0.3f animations:^ {
        self.y = yOffset;
    }];
}

@end

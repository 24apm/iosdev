//
//  ShopRowView.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface ShopRowView : XibView

@property (strong, nonatomic) IBOutlet UILabel *label;

- (void)setupWithItem:(NSString *)item;

@end

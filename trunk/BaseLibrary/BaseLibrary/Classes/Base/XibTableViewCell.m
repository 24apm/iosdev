//
//  XibTableViewCell.m
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibTableViewCell.h"
#import "XibView.h"

@implementation XibTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier className:(NSString *)className
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.view = [[NSClassFromString(className) alloc] init];
        self.size = self.view.size;
        [self addSubview:self.view];
    }
    return self;
}

@end

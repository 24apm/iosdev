//
//  XibTableViewCell.h
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XibTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *view;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier className:(NSString *)className;

@end

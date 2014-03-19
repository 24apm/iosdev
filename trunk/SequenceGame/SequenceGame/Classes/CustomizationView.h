//
//  CustomizationView.h
//  SpeedyBnA
//
//  Created by MacCoder on 3/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "CustomizationItemView.h"

#define CUSTOMIZE_VIEW_NOTIFICATION @"CUSTOMIZE_VIEW_NOTIFICATION"

@interface CustomizationView : XibView

@property (strong, nonatomic) IBOutletCollection(CustomizationItemView) NSArray *itemViews;

- (void)show;

@end

//
//  ParallaxWorldView.h
//  Weed
//
//  Created by MacCoder on 7/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface ParallaxWorldView : XibView <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *coinGainLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coinImageView;
@property (strong, nonatomic) IBOutlet UILabel *coinLabel;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *exitEditModebutton;
@property (strong, nonatomic) IBOutlet UILabel *editModeMessage;

- (void)setup;

@end

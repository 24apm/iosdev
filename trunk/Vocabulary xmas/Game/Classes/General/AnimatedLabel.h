//
//  AnimatedLabel.h
//  2048
//
//  Created by MacCoder on 4/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "THLabel.h"

@interface AnimatedLabel : XibView

@property (strong, nonatomic) IBOutlet UILabel *label;

- (void)animate;
- (void)animateSlow;

@end

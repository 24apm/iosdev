//
//  CoinMenuView.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CoinMenuView.h"

@implementation CoinMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)show {
    [super show];
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [super dismissed:self];
}
@end

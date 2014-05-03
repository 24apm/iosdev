//
//  ShopDialogView.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 4/30/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ShopDialogView.h"

@implementation ShopDialogView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (void)show {

        [[[ShopDialogView alloc] init] show];

}


- (void)show {
    [super show];

}

@end

//
//  BlockView.m
//  StackGame
//
//  Created by MacCoder on 1/17/15.
//  Copyright (c) 2015 MacCoder. All rights reserved.
//

#import "BlockView.h"

@implementation BlockView

- (void)blockLabelSetTo:(NSString *)string {
    self.label.text = string;
    if ([self.label.text isEqualToString:@""]) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}
@end

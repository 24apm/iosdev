//
//  BlockView.m
//  StackGame
//
//  Created by MacCoder on 1/17/15.
//  Copyright (c) 2015 MacCoder. All rights reserved.
//

#import "BlockView.h"

@implementation BlockView

- (void)blockSetTo:(BlockType)type {
    if (type <= 0) {
        self.label.text = @"";
    } else {
        self.label.text = [NSString stringWithFormat:@"%d", type];
    }
    self.fruitType = type;
   self.backgroundColor = [BlockManager colorForBlockType:type];
}

- (void)blockStateSetTo:(BlockState)state {
    self.state = state;
}

@end

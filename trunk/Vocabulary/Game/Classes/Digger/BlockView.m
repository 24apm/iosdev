//
//  BlockView.m
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BlockView.h"

@implementation BlockView

- (void)setupWithTier:(NSUInteger)tier
{
    self.tier = tier;
}

- (IBAction)buttonPressed:(id)sender {
}

- (void)showBlockerView:(BOOL)flag {
    self.blocker.hidden = !flag;
}

@end

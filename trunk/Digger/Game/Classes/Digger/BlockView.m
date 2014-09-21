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
    
}

- (IBAction)buttonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:BLOCK_PRESSED_NOTIFICATION object:self];
}

@end

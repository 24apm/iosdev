//
//  SlotView.m
//  2048
//
//  Created by MacCoder on 4/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "SlotView.h"

@implementation SlotView

- (void)unload {
    [self.tileView removeFromSuperview];
    self.tileView = nil;
    
    [self removeFromSuperview];
}

@end

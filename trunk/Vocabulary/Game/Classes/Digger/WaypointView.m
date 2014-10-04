//
//  ObstacleVIew.m
//  Digger
//
//  Created by MacCoder on 9/15/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "WaypointView.h"

@implementation WaypointView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)setupWithTier:(NSUInteger)tier {
    [super setupWithTier:tier];
    self.rank = tier;
    self.tierLabel.text = [NSString stringWithFormat:@"%d", self.rank];
}

@end

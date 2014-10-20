//
//  ObstacleVIew.m
//  Digger
//
//  Created by MacCoder on 9/15/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "WaypointView.h"
#import "UserData.h"

@implementation WaypointView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)doAction:(SlotView *)slotView {
    [super doAction:slotView];
    
    [[UserData instance] unlockWaypointRank:self.tier];
    NSInteger staminaCost = 1;
    [[UserData instance]decrementStamina:staminaCost];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_REFRESH_STAMINA object:nil];
    return YES;
}

- (void)setupWithTier:(NSUInteger)tier {
    [super setupWithTier:tier];
    self.rank = tier;
    self.tierLabel.text = [NSString stringWithFormat:@"%d", self.rank];
}

@end

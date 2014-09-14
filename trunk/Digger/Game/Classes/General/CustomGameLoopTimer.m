//
//  CustomGameLoopTimer.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CustomGameLoopTimer.h"

@implementation CustomGameLoopTimer

+ (GameLoopTimer *)instance {
    static CustomGameLoopTimer *gameLoopTimer;
    if (!gameLoopTimer) {
        gameLoopTimer = [[CustomGameLoopTimer alloc] init];
    }
    return gameLoopTimer;
}

- (CGFloat)loopInterval {
    return 1.f;
}

@end

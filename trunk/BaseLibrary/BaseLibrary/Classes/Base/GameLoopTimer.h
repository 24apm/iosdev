//
//  GameLoopTimer.h
//  Base
//
//  Created by MacCoder on 2/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "Prefix.h"

#define DRAW_STEP_NOTIFICATION @"DRAW_STEP_NOTIFICATION"

@interface GameLoopTimer : NSObject
{
    CADisplayLink *_timer;  // needs QuartzCore.framework to be linked with the project
}

+ (GameLoopTimer *)instance;
- (void) initialize;
- (CGFloat)loopInterval;

@end

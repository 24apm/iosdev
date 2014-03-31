//
//  TrackUtils.m
//  TimedTap
//
//  Created by MacCoder on 3/30/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "TrackUtils.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@implementation TrackUtils

+ (void)trackAction:(NSString *)action label:(NSString *)label {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:[[NSBundle mainBundle] bundleIdentifier]     // Event category (required)
                                                          action:action  // Event action (required)
                                                           label:label          // Event label
                                                           value:nil] build]];    // Event value
}

@end

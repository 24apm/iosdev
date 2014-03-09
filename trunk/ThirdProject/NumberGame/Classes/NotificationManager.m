//
//  NotificationManager.m
//  NumberGame
//
//  Created by MacCoder on 2/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "NotificationManager.h"
#import "Utils.h"

@implementation NotificationManager

+ (NotificationManager *)instance {
    static NotificationManager *instance = nil;
    if (!instance) {
        instance = [[NotificationManager alloc] init];
    }
    return instance;
}

- (NSArray *)notificationBodyTexts{
    return [NSArray arrayWithObjects:
            @"Ready to reach a new streak?",
            @"How far can you go?",
            @"Hungry for more?",
            nil];
}

- (NSArray *)notificationActionTexts {
    return [NSArray arrayWithObjects:
            @"Let's go!",
            @"Tapping time!",
            nil];
}

@end

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


@end

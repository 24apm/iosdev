//
//  AppDelegate.m
//  FlappyBall
//
//  Created by MacCoder on 2/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AppDelegate.h"
#import "iRate.h"
#import "NotificationManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[NotificationManager instance] registerNotifications];
    return YES;
}

@end

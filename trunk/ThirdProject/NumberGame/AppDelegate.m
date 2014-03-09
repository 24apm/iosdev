//
//  AppDelegate.m
//  NumberGame
//
//  Created by MacCoder on 2/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AppDelegate.h"
#import "iRate.h"
#import "NotificationManager.h"
#import "NumberGameIAPHelper.h"
#import "PromoManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];

    [[NotificationManager instance] registerNotifications];
    [[NumberGameIAPHelper sharedInstance] loadProduct];

    return YES;
}

@end

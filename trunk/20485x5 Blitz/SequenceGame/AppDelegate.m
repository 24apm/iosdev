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
#import "CoinIAPHelper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    [iRate sharedInstance].usesUntilPrompt = 2;
    [iRate sharedInstance].eventsUntilPrompt = 5;
    
    [[NotificationManager instance] registerNotifications];
    [[CoinIAPHelper sharedInstance] loadProduct];

    
    return YES;
}

@end

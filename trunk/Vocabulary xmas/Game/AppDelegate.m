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
#import "RootViewController.h"
#import "ConfigManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupConfig];
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    [iRate sharedInstance].usesUntilPrompt = 2;
    [iRate sharedInstance].eventsUntilPrompt = 5;

    [[CoinIAPHelper sharedInstance] loadProduct];

    RootViewController *myViewController = [[RootViewController alloc] init];
    self.navigationController = [[UINavigationController alloc]
                            initWithRootViewController:myViewController];
    self.navigationController.navigationBar.hidden = YES;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)setupConfig {
    [ConfigManager instance].ipadScale = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2.0f : 1.0f);
}

- (void)registerNotification {
    [super registerNotification];
    [[NotificationManager instance] registerNotifications];
}

@end

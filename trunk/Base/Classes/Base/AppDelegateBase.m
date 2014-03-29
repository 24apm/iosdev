//
//  AppDelegate.m
//  NumberGame
//
//  Created by MacCoder on 2/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AppDelegateBase.h"
#import "iRate.h"
#import "NotificationManager.h"
#import "PromoManager.h"
#import "AppInfoHTTPRequest.h"

@implementation AppDelegateBase

+ (void)initialize
{
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
//    [iRate sharedInstance].applicationBundleID = @"com.charcoaldesign.rainbowblocks-free";
    
    //enable preview mode
    [iRate sharedInstance].previewMode = NO;
    
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 0;
    [iRate sharedInstance].usesUntilPrompt = 3;
    [iRate sharedInstance].eventsUntilPrompt = 10;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    self.window.frame = UIScreen.mainScreen.applicationFrame;

    [self.window addSubview:self.viewController.view];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = self.viewController;
    
    AppInfoHTTPRequest *request = [[AppInfoHTTPRequest alloc] initWithURL:@"https://itunes.apple.com/search?term=jeffrey+wan&entity=software"];
    [request send];
    
    return YES;
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // reset badge
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

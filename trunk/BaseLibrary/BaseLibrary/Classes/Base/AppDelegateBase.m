//
//  AppDelegate.m
//  NumberGame
//
//  Created by MacCoder on 2/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AppDelegateBase.h"
#import "NotificationManagerBase.h"
#import "PromoManager.h"
#import "AppInfoHTTPRequest.h"
#import "GAI.h"
#import "TrackUtils.h"

@implementation AppDelegateBase

+ (void)initialize
{
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
    //[iRate sharedInstance].applicationBundleID = @"com.jeffrwan.20485x5";
    
    //enable preview mode
    [iRate sharedInstance].previewMode = NO;
    [iRate sharedInstance].promptAtLaunch = NO;

    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 0;
    [iRate sharedInstance].usesUntilPrompt = 2;
    [iRate sharedInstance].eventsUntilPrompt = 6;
}

- (void)iRateCouldNotConnectToAppStore:(NSError *)error {
    [TrackUtils trackAction:@"iRate" label:@"iRateCouldNotConnectToAppStore"];
}

- (void)iRateDidDetectAppUpdate:(NSError *)error {
    [TrackUtils trackAction:@"iRate" label:@"iRateDidDetectAppUpdate"];
}

- (void)iRateDidPromptForRating {
    [TrackUtils trackAction:@"iRate" label:@"iRateDidPromptForRating"];
}

- (void)iRateUserDidAttemptToRateApp {
    [TrackUtils trackAction:@"iRate" label:@"iRateUserDidAttemptToRateApp"];
}

- (void)iRateUserDidDeclineToRateApp {
    [TrackUtils trackAction:@"iRate" label:@"iRateUserDidDeclineToRateApp"];
}

- (void)iRateUserDidRequestReminderToRateApp {
    [TrackUtils trackAction:@"iRate" label:@"iRateUserDidRequestReminderToRateApp"];
}

- (void)iRateDidOpenAppStore {
    [TrackUtils trackAction:@"iRate" label:@"iRateDidOpenAppStore"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAnalytics];
    
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    [iRate sharedInstance].delegate = self;

    self.window.frame = UIScreen.mainScreen.applicationFrame;

    [self.window addSubview:self.viewController.view];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = self.viewController;
    
    
    // Promo
    AppInfoHTTPRequest *request = [[AppInfoHTTPRequest alloc] initWithURL:@"https://itunes.apple.com/search?term=jeffrey+wan&entity=software"];
    [request send];
    
    return YES;
}

- (void)setupAnalytics {
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
//    // Optional: set Logger to VERBOSE for debug information.
//    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-49468052-2"];
    
    [TrackUtils trackAction:@"game_impression" label:@"AppDelegateBase"];
    [TrackUtils trackDevice];
    

    [[GAI sharedInstance] dispatch];
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
    [[GAI sharedInstance] dispatch];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[GAI sharedInstance] dispatch];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // reset badge
    application.applicationIconBadgeNumber = 0;
    [[GAI sharedInstance] dispatch];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[GAI sharedInstance] dispatch];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[GAI sharedInstance] dispatch];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

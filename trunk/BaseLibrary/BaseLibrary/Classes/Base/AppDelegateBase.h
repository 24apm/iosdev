//
//  AppDelegate.h
//  NumberGame
//
//  Created by MacCoder on 2/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iRate.h"

@interface AppDelegateBase : UIResponder <UIApplicationDelegate, iRateDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UIViewController *viewController;

@end

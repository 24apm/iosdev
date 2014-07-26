//
//  NotificationManager.h
//  NumberGame
//
//  Created by MacCoder on 2/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManagerBase : NSObject

+ (NotificationManagerBase *)instance;
- (void)registerNotifications;

// override
- (NSArray *)notificationBodyTexts;
- (NSArray *)notificationActionTexts;

@end

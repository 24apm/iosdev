//
//  NotificationManager.h
//  FlappyBall
//
//  Created by MacCoder on 2/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

+ (NotificationManager *)instance;
- (void)registerNotifications;

@end

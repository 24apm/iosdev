//
//  TrackUtils.h
//  TimedTap
//
//  Created by MacCoder on 3/30/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackUtils : NSObject

+ (void)trackAction:(NSString *)action label:(NSString *)label;
+ (void)trackDevice;

@end

//
//  Utils.h
//  Fighting
//
//  Created by 15inch on 5/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+Util.h"

#define DegreesToRadians(x)     (M_PI * (x) / 180.0)
#define CURRENT_TIME [[NSDate date] timeIntervalSince1970]

#define CLAMP(x, low, high) ({\
__typeof__(x) __x = (x); \
__typeof__(low) __low = (low);\
__typeof__(high) __high = (high);\
__x > __high ? __high : (__x < __low ? __low : __x);\
})

@interface Utils : NSObject

+ (CGSize)screenSize;
+ (float)randBetweenMin:(float)min max:(float)max;
+ (int)randBetweenMinInt:(int)min max:(int)max;
+ (UIViewController *)rootViewController;
+ (NSString *)formatWithComma:(int)integer;
+ (NSString *)formatWithFreeCost:(int)cost;
+ (UIImage *)imageNamed:(UIImage *)img withColor:(UIColor *)color blendMode:(CGBlendMode)blendMode;
+ (NSString *)formatLongLongWithComma:(long long)integer;
+ (NSString *)formatLongLongWithShortHand:(long long)integer;
+ (NSString *)formatTime:(double)time;

@end

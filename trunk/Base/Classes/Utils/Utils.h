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

@interface Utils : NSObject

+ (CGSize)screenSize;
+ (float)randBetweenMin:(float)min max:(float)max;
+ (int)randBetweenMinInt:(int)min max:(int)max;
+ (UIViewController *)rootViewController;
+ (NSString *)formatWithComma:(int)integer;

@end

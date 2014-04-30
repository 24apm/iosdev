//
//  Utils.m
//  Fighting
//
//  Created by 15inch on 5/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "AppDelegateBase.h"

#define ARC4RANDOM_MAX 0x100000000

@implementation Utils

+ (CGSize)screenSize {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    UIInterfaceOrientation currentOrientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    
    if (currentOrientation != UIInterfaceOrientationPortrait){
        screenSize.width = [[UIScreen mainScreen] bounds].size.height;
        screenSize.height = [[UIScreen mainScreen] bounds].size.width;
    }
    return screenSize;
}

+ (float)randBetweenMin:(float)min max:(float)max {
    return ((float)arc4random() / ARC4RANDOM_MAX) * (max-min) + min;
}

+ (int)randBetweenMinInt:(int)min max:(int)max {
    return arc4random() % (max-min + 1) + min;
}

+ (UIViewController *)rootViewController {
    AppDelegateBase *appDelegateBase = [UIApplication sharedApplication].delegate;
    return appDelegateBase.window.rootViewController;
}

+ (NSString *)formatWithComma:(int)integer {
    NSString *formattedInteger = [NSNumberFormatter localizedStringFromNumber:@(integer) numberStyle:NSNumberFormatterDecimalStyle];
    return formattedInteger;
}

@end

//
//  Utils.m
//  Fighting
//
//  Created by 15inch on 5/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <sys/utsname.h>
#import <objc/runtime.h>
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

+ (BOOL)randBetweenTrueFalse {
   NSInteger test = [self randBetweenMinInt:0 max:1];
    if (test == 1) {
        return true;
    } else {
        return false;
    }
}


+ (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (NSString *)formatWithComma:(int)integer {
    static NSNumberFormatter *formattedInteger = nil;
    if (!formattedInteger) {
        formattedInteger = [[NSNumberFormatter alloc] init];
        formattedInteger.numberStyle = NSNumberFormatterDecimalStyle;
    }
    //    NSString *formattedInteger = [NSNumberFormatter localizedStringFromNumber:@(integer) numberStyle:NSNumberFormatterDecimalStyle];
    return [formattedInteger stringFromNumber:@(integer)];
}

+ (NSString *)formatLongLongWithComma:(long long)integer {
    static NSNumberFormatter *formattedInteger = nil;
    if (!formattedInteger) {
        formattedInteger = [[NSNumberFormatter alloc] init];
        formattedInteger.numberStyle = NSNumberFormatterDecimalStyle;
    }
    //    NSString *formattedInteger = [NSNumberFormatter localizedStringFromNumber:@(integer) numberStyle:NSNumberFormatterDecimalStyle];
    return [formattedInteger stringFromNumber:@(integer)];
}

+ (NSString *)formatLongLongWithShortHand:(long long)integer {
    static NSNumberFormatter *formattedInteger = nil;
    NSString *measurement = @"";
    if (!formattedInteger) {
        formattedInteger = [[NSNumberFormatter alloc] init];
        formattedInteger.numberStyle = NSNumberFormatterDecimalStyle;
    }
    
    double convertedInteger = 0;
    if (integer > 1000000000) {
        convertedInteger = ((double)integer) / 1000000000.f;
        measurement = @"b";
    } else if (integer > 1000) {
        convertedInteger = ((double)integer) / 1000.f;
        measurement = @"k";
    } else if (integer > 0) {
        convertedInteger = ((double)integer);
        measurement = @"";
    }
    
    NSString *finalFormat = [formattedInteger stringFromNumber:@(convertedInteger)];
    finalFormat = [finalFormat stringByAppendingString:measurement];
    return finalFormat;
}

+ (NSString *)formatTime:(int)time {
    NSString *timeString = nil;
    
    int duration = time;
    int hours = duration / 3600;
    int minutes = duration % 3600 / 60;
    int seconds = duration % 60;
    
    if (seconds > 0) {
        timeString = [NSString stringWithFormat:@"%ds",seconds];
    }
    
    if (minutes > 0) {
        if (timeString) {
            timeString = [NSString stringWithFormat:@"%dm %@", minutes, timeString];
        } else {
            timeString = [NSString stringWithFormat:@"%dm", minutes];
        }
    }
    
    if (hours > 0) {
        if (timeString) {
            timeString = [NSString stringWithFormat:@"%dh %@", hours, timeString];
        } else {
            timeString = [NSString stringWithFormat:@"%dh", hours];
        }
    }
    
    if (!timeString) {
        timeString = @"0s";
    }
    
    return timeString;
}

+ (NSString *)formatWithFreeCost:(int)cost {
    if (cost > 0) {
        return [NSString stringWithFormat:@"%d",cost];
    } else {
        return @"FREE";
    }
}

+ (UIImage *)imageNamed:(UIImage *)img withColor:(UIColor *)color blendMode:(CGBlendMode)blendMode {
    
    if (!img) return nil;
    // load the image
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContextWithOptions(img.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == nil) {
        NSLog(@"*** context: %s", __PRETTY_FUNCTION__);
    }
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, blendMode);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

+ (NSString*)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSString *)reverseString:(NSString *)string {
    
    NSMutableString *reversedString = [NSMutableString string];
    NSInteger charIndex = [string length];
    while (charIndex > 0) {
        charIndex--;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reversedString appendString:[string substringWithRange:subStrRange]];
    }
    return reversedString;
}

@end

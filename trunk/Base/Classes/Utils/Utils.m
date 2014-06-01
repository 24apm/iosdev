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

+ (NSString *)formatWithFreeCost:(int)cost {
    if (cost > 0) {
        return [NSString stringWithFormat:@"%d",cost];
    } else {
        return @"FREE";
    }
}

+ (UIImage *)imageNamed:(UIImage *)img withColor:(UIColor *)color blendMode:(CGBlendMode)blendMode {
    
    
    // load the image
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContextWithOptions(img.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
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


@end

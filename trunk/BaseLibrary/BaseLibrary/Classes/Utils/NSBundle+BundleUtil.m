//
//  NSBundle+BundleUtil.m
//  BaseLibrary
//
//  Created by MacCoder on 8/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "NSBundle+BundleUtil.h"

@implementation NSBundle (BundleUtil)

+ (NSBundle*)myLibraryResourcesBundle {
    static dispatch_once_t onceToken;
    static NSBundle *myLibraryResourcesBundle = nil;
    dispatch_once(&onceToken, ^{
        myLibraryResourcesBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"BaseLibraryResource" withExtension:@"bundle"]];
    });
    return myLibraryResourcesBundle;
}

@end

@implementation UIImage (BundleUtil)

+ (UIImage*)myLibraryImageNamed:(NSString*)name {
    UIImage *imageFromMainBundle = [UIImage imageNamed:name];
    if (imageFromMainBundle) {
        return imageFromMainBundle;
    }
    
    UIImage *imageFromMyLibraryBundle = [UIImage imageWithContentsOfFile:[[[NSBundle myLibraryResourcesBundle] resourcePath] stringByAppendingPathComponent:name]];
    return imageFromMyLibraryBundle;
}

@end
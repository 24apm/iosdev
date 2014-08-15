//
//  NSBundle+BundleUtil.h
//  BaseLibrary
//
//  Created by MacCoder on 8/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (BundleUtil)

+ (NSBundle*)myLibraryResourcesBundle;

@end

@interface UIImage (BundleUtil)

+ (UIImage*)myLibraryImageNamed:(NSString*)name;

@end
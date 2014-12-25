//
//  NSString+StringUtils.h
//  BaseLibrary
//
//  Created by MacCoder on 10/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringUtils)

@property (nonatomic, readonly) NSString *reversedString;

+ (NSString *)shuffleString:(NSString *)string;
- (BOOL)hasSubString:(NSString *)string;

@end

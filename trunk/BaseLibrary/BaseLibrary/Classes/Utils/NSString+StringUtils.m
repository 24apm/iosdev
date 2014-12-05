//
//  NSString+StringUtils.m
//  BaseLibrary
//
//  Created by MacCoder on 10/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "NSString+StringUtils.h"
#import "Utils.h"

@implementation NSString (StringUtils)

- (NSString *)reversedString
{
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:self.length];
    
    [self enumerateSubstringsInRange:NSMakeRange(0,self.length)
                             options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              [reversedString appendString:substring];
                          }];
    return reversedString;
}

+ (NSString *) shuffleString:(NSString *)string {
    
    if (string.length <= 0) {
        return @"";
    }
    
    NSString *shuffleString = @"";
    
    NSInteger totalNumber = string.length;
    NSInteger currentLength = totalNumber;
    NSMutableArray *randomOrder = [NSMutableArray array];
    for (NSInteger i = 0; i< currentLength; i++) {
        [randomOrder addObject:[NSNumber numberWithInteger:i]];
    }
    [randomOrder shuffle];
    
    
    for (NSInteger i = 0; i < randomOrder.count; i++) {
        shuffleString = [shuffleString stringByAppendingString:[NSString stringWithFormat:@"%c", [string characterAtIndex:[[randomOrder objectAtIndex:i]integerValue ]]]];
    }
    
    return shuffleString;
    
}
@end

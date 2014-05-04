//
//  SKProduct+priceAsString.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "SKProduct+priceAsString.h"

@implementation SKProduct (priceAsString)

- (NSString *) priceAsString
{
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setLocale:[self priceLocale]];
    }
    
   return [formatter stringFromNumber:[self price]];
}

@end

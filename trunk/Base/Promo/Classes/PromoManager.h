//
//  PromoManager.h
//  NumberGame
//
//  Created by MacCoder on 3/2/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PromoGameData.h"

@interface PromoManager : NSObject

+ (PromoManager *)instance;

- (void)addPromo:(PromoGameData *)gameData;
- (void)goToAppStore:(NSString *)actionURL;
- (PromoGameData *)nextPromo;
- (NSArray *)nextPromoSetWithSize:(int)size;
- (void)promoPressed:(PromoGameData *)promoGameData;

@end

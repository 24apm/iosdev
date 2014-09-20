//
//  PromoManager.h
//  NumberGame
//
//  Created by MacCoder on 3/2/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PromoGameData.h"
#import <StoreKit/StoreKit.h>

@interface PromoManager : NSObject <SKStoreProductViewControllerDelegate>

+ (PromoManager *)instance;

- (void)addPromo:(PromoGameData *)gameData;
- (void)goToAppStore:(PromoGameData *)actionURL;
- (PromoGameData *)nextPromo;
- (NSArray *)nextPromoSetWithSize:(int)size;
- (void)promoPressed:(PromoGameData *)promoGameData;

@end

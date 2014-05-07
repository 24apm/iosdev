//
//  PurchaseManager.h
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/1/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameData.h"
#import "UserData.h"
#import "TrackUtils.h"

#define NOT_ENOUGH_COIN_NOTIFICATION @"NOT_ENOUGH_COIN_NOTIFICATION"

typedef enum {
    PowerUpTypeShuffle,
    PowerUpTypeBomb2,
    PowerUpTypeBomb4,
    PowerUpTypeRevive
} PowerUpType;

@interface PurchaseManager : NSObject

+ (PurchaseManager *)instance;

- (BOOL)purchasePowerUp:(PowerUpType)type;

@end

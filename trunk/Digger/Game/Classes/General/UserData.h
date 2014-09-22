//
//  UserData.h
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameConstants.h"

#define DEFAULT_STAMINA 10.f

extern NSString *const UserDataHouseDataChangedNotification;

@interface UserData : NSObject

+ (UserData *)instance;

- (BOOL)hasCoin:(long long)coin;
- (void)incrementCoin:(long long)coin;
- (void)decrementCoin:(long long)coin;

- (void)incrementStamina:(long long)stamina;
- (void)decrementStamina:(long long)stamina;
- (void)incrementStaminaCapacity:(long long)stamina;
- (float)formatPercentageStamina;
- (void)refillStamina;

@property (nonatomic) long long coin;
@property (nonatomic) long long stamina;
@property (nonatomic) long long staminaCapacity;

@end

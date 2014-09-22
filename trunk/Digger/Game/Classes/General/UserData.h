//
//  UserData.h
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameConstants.h"


extern NSString *const UserDataHouseDataChangedNotification;

@interface UserData : NSObject

+ (UserData *)instance;

- (BOOL)hasCoin:(long long)coin;
- (void)incrementCoin:(long long)coin;
- (void)decrementCoin:(long long)coin;

- (void)incrementStamina:(long long)stamina;
- (void)decrementStamina:(long long)stamina;
- (void)incrementLevelStaminaCapacity;
- (float)formatPercentageStamina;
- (void)refillStamina;

@property (nonatomic) long long coin;
@property (nonatomic) long long stamina;
@property (nonatomic) long long staminaCapacity;
@property (nonatomic) long long staminaCapcityLevel;

@end

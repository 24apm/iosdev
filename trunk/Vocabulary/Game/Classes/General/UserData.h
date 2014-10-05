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

- (void)decrementRetry;
- (void)refillRetry;
- (BOOL)hasRetry;

@property (nonatomic) long long coin;

@property (nonatomic) NSInteger retry;
@property (nonatomic) NSInteger retryCapacity;

@end

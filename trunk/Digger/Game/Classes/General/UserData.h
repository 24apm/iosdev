//
//  UserData.h
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameConstants.h"

#define MAX_HOUSES 9

extern NSString *const UserDataHouseDataChangedNotification;

@interface UserData : NSObject

+ (UserData *)instance;

- (void)incrementCoin:(long long)coin;
- (void)decrementCoin:(long long)coin;

@property (nonatomic) long long coin;

@end

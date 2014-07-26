//
//  UserData.h
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameConstants.h"
#import "HouseData.h"

#define MAX_HOUSES 9

extern NSString *const UserDataHouseDataChangedNotification;

@interface UserData : NSObject

+ (UserData *)instance;

- (void)incrementCoin:(long long)coin;
- (void)decrementCoin:(long long)coin;

- (void)addHouse:(HouseData *)houseData;
- (void)removeHouse:(HouseData *)houseData;
- (void)saveHouse;
- (HouseData *)randomUserHouse;

- (void)resetUserData;

- (void)addUserPassive;

@property (nonatomic) long long coin;

@property (nonatomic) int userPassive;

@property (strong, nonatomic) NSMutableArray *houses;
@property (nonatomic) int houseIndex;

@end

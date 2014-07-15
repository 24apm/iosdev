//
//  UserData.h
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameConstants.h"
#import "HouseData.h"

extern NSString *const UserDataHouseDataChangedNotification;

@interface UserData : NSObject

+ (UserData *)instance;

- (void)incrementCoin:(long long)coin;
- (void)decrementCoin:(long long)coin;

- (void)addHouse:(HouseData *)houseData;
- (void)removeHouse:(HouseData *)houseData;
- (void)saveHouse;
- (HouseData *)randomUserHouse;

@property (nonatomic) long long coin;
@property (strong, nonatomic) NSMutableArray *houses;
@property (nonatomic) int houseIndex;

@end

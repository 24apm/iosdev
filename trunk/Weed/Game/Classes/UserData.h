//
//  UserData.h
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameConstants.h"

@interface UserData : NSObject

+ (UserData *)instance;

- (void)incrementCoin:(int)coin;
- (void)decrementCoin:(int)coin;

@property (nonatomic) int coin;

@end

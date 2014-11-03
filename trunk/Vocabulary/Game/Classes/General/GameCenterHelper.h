//
//  GameCenterHelper.h
//  NumberGame
//
//  Created by MacCoder on 3/1/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameCenterHelperBase.h"
#define SHOW_ACHIEVETMENT_EARNED @"SHOW_ACHIEVETMENT_EARNED"

@interface GameCenterHelper : GameCenterHelperBase

+ (GameCenterHelper *)instance;
- (void)login;

@property (nonatomic, strong) NSString *imgName;

@end

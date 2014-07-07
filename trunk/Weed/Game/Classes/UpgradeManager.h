//
//  UpgradeManager.h
//  Make It Flappy
//
//  Created by MacCoder on 6/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserData.h"
#import "ShopManager.h"
#import "GameConstants.h"

@interface UpgradeManager : NSObject


@property (nonatomic) long long cost;
@property (nonatomic) float chance;
@property (nonatomic, strong) ShopItem *item;

+ (UpgradeManager *)instance;

- (void)attemptUpgrade:(ShopItem *) item;

@end

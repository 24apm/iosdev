//
//  UpgradeManager.m
//  Make It Flappy
//
//  Created by MacCoder on 6/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UpgradeManager.h"

#define ARC4RANDOM_MAX      0x100000000

@implementation UpgradeManager

+ (UpgradeManager *)instance {
    static UpgradeManager *instance = nil;
    if (!instance) {
        instance = [[UpgradeManager alloc] init];
    }
    return instance;
}

-(id)init {
    self.chance = 1.0;
    return self;
}

- (void)attemptUpgrade:(ShopItem *) item {
    
    [UserData instance].currentScore -= [[ShopManager instance] priceForItemId:item.itemId type:item.type];
    [[UserData instance] saveUserCoin];
    
    double val = ((double)arc4random() / ARC4RANDOM_MAX);
    if (val <= self.chance) {
           [[UserData instance] levelUpPower:item];
    }

    [[NSNotificationCenter defaultCenter]postNotificationName:UPGRADE_ATTEMPT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:SHOP_BUTTON_PRESSED_NOTIFICATION object:item];
}

@end

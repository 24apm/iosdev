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
    self.chance = [self riskLevel:[[ShopManager instance] itemLevel:item.itemId type:item.type]];
    double val = ((double)arc4random() / ARC4RANDOM_MAX);
    if (val <= self.chance) {
           [[UserData instance] levelUpPower:item];
    }

    [[NSNotificationCenter defaultCenter]postNotificationName:UPGRADE_ATTEMPT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:SHOP_BUTTON_PRESSED_NOTIFICATION object:item];
}

- (float)riskLevel:(int)lvl {
    switch (lvl) {
        case 1:
            return 1.f;
            break;
        case 2:
            return 1.f;
            break;
        case 3:
            return 1.f;
            break;
        case 4:
            return 1.f;
            break;
        case 5:
            return 1.f;
            break;
        case 6:
            return 0.8f;
            break;
        case 7:
            return 0.8f;
            break;
        case 8:
            return 0.8f;
            break;
        case 9:
            return 0.8f;
            break;
        case 10:
            return 0.8f;
            break;
        case 11:
            return 0.7f;
            break;
        case 12:
            return 0.6f;
            break;
        case 13:
            return 0.5f;
            break;
        case 14:
            return 0.5f;
            break;
        case 15:
            return 0.5f;
            break;
        case 16:
            return 0.4f;
            break;
        case 17:
            return 0.4f;
            break;
        case 18:
            return 0.3f;
            break;
        case 19:
            return 0.3f;
            break;
        case 20:
            return 0.2f;
            break;
        case 21:
            return 0.1f;
            break;
        case 22:
            return 0.05f;
            break;
        case 23:
            return 0.04f;
            break;
        case 24:
            return 0.03f;
            break;
        default:
            return 0.01f;
            break;
    }
}

@end

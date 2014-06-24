//
//  UpgradeManager.m
//  Make It Flappy
//
//  Created by MacCoder on 6/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UpgradeManager.h"

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
    self.item = item;
    [UserData instance].currentScore -= [[ShopManager instance] priceForItemId:item.itemId type:item.type];
    [[UserData instance] saveUserCoin];
    self.chance = [self riskLevel:[[ShopManager instance] itemLevel:item.itemId type:item.type]];
    int val = (arc4random() % 1000);
    if (val <= self.chance) {
        [[UserData instance] levelUpPower:item];
        [[NSNotificationCenter defaultCenter]postNotificationName:UPGRADE_ATTEMPT_SUCCESS_NOTIFICATION object:nil];
    } else {
        [[NSNotificationCenter defaultCenter]postNotificationName:UPGRADE_ATTEMPT_FAIL_NOTIFICATION object:nil];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successUpgradeAnimationFinish) name:SUCCESS_UPGRADE_ANIMATION_FINISH_NOTIFICATION object:nil];
    
}

- (void)successUpgradeAnimationFinish {
    [[NSNotificationCenter defaultCenter]postNotificationName:UPGRADE_ATTEMPT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:SHOP_BUTTON_PRESSED_NOTIFICATION object:self.item];
    
}

- (int)riskLevel:(int)lvl {
    switch (lvl) {
        case 1:
            return 1000;
            break;
        case 2:
            return 1000;
            break;
        case 3:
            return 1000;
            break;
        case 4:
            return 1000;
            break;
        case 5:
            return 900;
            break;
        case 6:
            return 800;
            break;
        case 7:
            return 700;
            break;
        case 8:
            return 600;
            break;
        case 9:
            return 500;
            break;
        case 10:
            return 400;
            break;
        case 11:
            return 300;
            break;
        case 12:
            return 200;
            break;
        case 13:
            return 100;
            break;
        case 14:
            return 50;
            break;
        case 15:
            return 40;
            break;
        case 16:
            return 30;
            break;
        case 17:
            return 20;
            break;
        case 18:
            return 10;
            break;
        case 19:
            return 10;
            break;
        case 20:
            return 5;
            break;
        case 21:
            return 4;
            break;
        case 22:
            return 3;
            break;
        case 23:
            return 2;
            break;
        case 24:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

@end

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
    int val = (arc4random() % 100);
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
            return 100;
            break;
        case 2:
            return 100;
            break;
        case 3:
            return 100;
            break;
        case 4:
            return 100;
            break;
        case 5:
            return 90;
            break;
        case 6:
            return 90;
            break;
        case 7:
            return 90;
            break;
        case 8:
            return 90;
            break;
        case 9:
            return 90;
            break;
        case 10:
            return 80;
            break;
        case 11:
            return 80;
            break;
        case 12:
            return 80;
            break;
        case 13:
            return 80;
            break;
        case 14:
            return 80;
            break;
        case 15:
            return 80;
            break;
        case 16:
            return 70;
            break;
        case 17:
            return 70;
            break;
        case 18:
            return 70;
            break;
        case 19:
            return 70;
            break;
        case 20:
            return 70;
            break;
        case 21:
            return 60;
            break;
        case 22:
            return 60;
            break;
        case 23:
            return 60;
            break;
        case 24:
            return 60;
            break;
        case 25:
            return 60;
            break;
        case 26:
            return 50;
            break;
        case 27:
            return 50;
            break;
        case 28:
            return 50;
            break;
        case 29:
            return 50;
            break;
        case 30:
            return 50;
            break;
        case 31:
            return 40;
            break;
        case 32:
            return 40;
            break;
        case 33:
            return 40;
            break;
        case 34:
            return 40;
            break;
        case 35:
            return 40;
            break;
        case 36:
            return 30;
            break;
        case 37:
            return 30;
            break;
        case 38:
            return 30;
            break;
        case 39:
            return 30;
            break;
        case 40:
            return 30;
            break;
        case 41:
            return 20;
            break;
        case 42:
            return 20;
            break;
        case 43:
            return 20;
            break;
        case 44:
            return 20;
            break;
        case 45:
            return 20;
            break;
        case 46:
            return 15;
            break;
        case 47:
            return 15;
            break;
        case 48:
            return 15;
            break;
        case 49:
            return 15;
            break;
        case 50:
            return 15;
            break;
        case 51:
            return 10;
            break;
        case 52:
            return 10;
            break;
        case 53:
            return 10;
            break;
        case 54:
            return 10;
            break;
        case 55:
            return 10;
            break;
        case 56:
            return 10;
            break;
        case 57:
            return 10;
            break;
        case 58:
            return 10;
            break;
        case 59:
            return 10;
            break;
        case 60:
            return 10;
            break;
        default:
            return 5;
            break;

    }
}

@end

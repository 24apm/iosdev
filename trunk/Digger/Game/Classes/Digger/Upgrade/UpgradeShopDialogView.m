//
//  UpgradeShopDialogView.m
//  Digger
//
//  Created by MacCoder on 9/21/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UpgradeShopDialogView.h"
#import "UserData.h"

#define UPGRADE_STAMINA_INCREMENT 2

@interface UpgradeShopDialogView()

@property (strong, nonatomic) IBOutlet UILabel *staminaLabel;
@property (strong, nonatomic) IBOutlet UILabel *staminaNextLvlLabel;

@end

@implementation UpgradeShopDialogView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self refresh];

    }
    return self;
}

- (IBAction)upgradeStaminaPressed:(id)sender {
    if ([[UserData instance] hasCoin:10]) {
        [[UserData instance] incrementStaminaCapacity:UPGRADE_STAMINA_INCREMENT];
        [[UserData instance] decrementCoin:10];
        [self refresh];
    }
}

- (void)refresh {
    self.staminaLabel.text = [NSString stringWithFormat:@"%lld",  [UserData instance].staminaCapacity];
    self.staminaNextLvlLabel.text = [NSString stringWithFormat:@"%lld",  [UserData instance].staminaCapacity + UPGRADE_STAMINA_INCREMENT];
}

@end

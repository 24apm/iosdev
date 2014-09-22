//
//  UpgradeShopDialogView.m
//  Digger
//
//  Created by MacCoder on 9/21/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UpgradeShopDialogView.h"
#import "UserData.h"
#import "LevelManager.h"
#import "MessageDialogView.h"

#define UPGRADE_STAMINA_INCREMENT 2

@interface UpgradeShopDialogView()

@property (strong, nonatomic) IBOutlet UILabel *staminaLabel;
@property (strong, nonatomic) IBOutlet UILabel *staminaNextLvlLabel;
@property (strong, nonatomic) IBOutlet UIButton *staminaBuyButton;

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
    if ([[LevelManager instance] purchaseStaminaUpgrade]) {
        [self refresh];
    } else {
        [[[MessageDialogView alloc] initWithHeaderText:@"Uh oh" bodyText:@"Don't have enough gold!" ] show];
    }
}

- (void)refresh {
    self.staminaLabel.text = [NSString stringWithFormat:@"%lld",  [UserData instance].staminaCapacity];
    
    long long nextStaminaCapacity = [[LevelManager instance] staminaCapacityForLevel:[UserData instance].staminaCapcityLevel + 1];
    self.staminaNextLvlLabel.text = [NSString stringWithFormat:@"%lld", nextStaminaCapacity];
    
     long long cost = [[LevelManager instance] staminaUpgradeCostForLevel:[UserData instance].staminaCapcityLevel + 1];
    
    [self.staminaBuyButton setTitle: [NSString stringWithFormat:@"%lld", cost] forState:UIControlStateNormal];
}

@end

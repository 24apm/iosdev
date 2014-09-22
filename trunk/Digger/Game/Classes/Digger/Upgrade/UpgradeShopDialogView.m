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
@property (strong, nonatomic) IBOutlet UILabel *staminaDisplayLabel;

@property (strong, nonatomic) IBOutlet UILabel *drillLvlLabel;

@property (strong, nonatomic) IBOutlet UILabel *drillNextLvlLabel;
@property (strong, nonatomic) IBOutlet UIButton *drillBuyButton;
@property (strong, nonatomic) IBOutlet UILabel *drillDisplayLabel;

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
- (IBAction)upgradeDrillPressed:(id)sender {
    if ([[LevelManager instance] purchaseDrillUpgrade]) {
        [self refresh];
    } else {
        [[[MessageDialogView alloc] initWithHeaderText:@"Uh oh" bodyText:@"Don't have enough gold!" ] show];
    }
}

- (void)refresh {
    // stamina
    self.staminaLabel.text = [NSString stringWithFormat:@"%lld",  [UserData instance].staminaCapacity];
    
    long long nextStaminaCapacity = [[LevelManager instance] staminaCapacityForLevel:[UserData instance].staminaCapacityLevel + 1];
    self.staminaNextLvlLabel.text = [NSString stringWithFormat:@"%lld", nextStaminaCapacity];
    
     long long cost = [[LevelManager instance] staminaUpgradeCostForLevel:[UserData instance].staminaCapacityLevel + 1];
    
    [self.staminaBuyButton setTitle: [NSString stringWithFormat:@"%lld", cost] forState:UIControlStateNormal];
    self.staminaDisplayLabel.text = [NSString stringWithFormat:@"Lvl %lld", [UserData instance].staminaCapacityLevel];
    
    // drill
    self.drillLvlLabel.text = [NSString stringWithFormat:@"%lld",  [UserData instance].drillLevel];
    
    long long nextDrillPower = [[LevelManager instance] drillPowerForLevel:[UserData instance].drillLevel + 1];
    self.drillNextLvlLabel.text = [NSString stringWithFormat:@"%lld", nextDrillPower];
    
    long long drillCost = [[LevelManager instance] drillUpgradeCostForLevel:[UserData instance].drillLevel + 1];
    
    [self.drillBuyButton setTitle: [NSString stringWithFormat:@"%lld", drillCost] forState:UIControlStateNormal];
    
    self.drillDisplayLabel.text = [NSString stringWithFormat:@"Lvl %lld", [UserData instance].drillLevel];


}

@end

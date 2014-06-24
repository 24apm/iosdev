//
//  UpgradeView.m
//  Make It Flappy
//
//  Created by MacCoder on 6/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UpgradeView.h"
#import "AnimatedLabel.h"
#import "ShopManager.h"
#import "UpgradeResultView.h"
#import "GameConstants.h"

@implementation UpgradeView

- (IBAction)LvlButtonPressed:(id)sender {
    if ([UserData instance].currentScore >= self.cost) {
        [[UpgradeManager instance] attemptUpgrade:self.item];
        [self animateLabelForUpgrade];
    }
}

- (void)show:(ShopItem *)item {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:UPGRADE_ATTEMPT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upgradeSuccess) name:UPGRADE_ATTEMPT_SUCCESS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upgradeFail) name:UPGRADE_ATTEMPT_FAIL_NOTIFICATION object:nil];
    [super show];
    self.item = item;
    [self refresh];
}

- (void)upgradeSuccess {
    [[[UpgradeResultView alloc] init] showSuccess];
}

- (void)upgradeFail {
    [[[UpgradeResultView alloc] init] showFail];
    
}
- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:sender];
}

- (IBAction)closeButtonPressed:(UIButton *)sender {
    [self dismissed:self];
}

- (void)refresh {
    self.cost = [[ShopManager instance] priceForItemId:self.item.itemId type:self.item.type];
    self.currentExpLabel.text = [NSString stringWithFormat:@"%@",[Utils formatLongLongWithComma:[UserData instance].currentScore]];
    self.nextCostLabel.text = [NSString stringWithFormat:@"-%@",[Utils formatLongLongWithComma:self.cost]];
    long long tempResult = [UserData instance].currentScore;
    tempResult -= self.cost;
    self.afterCostLabel.text = [NSString stringWithFormat:@"%@",[Utils formatLongLongWithComma:tempResult]];
}

- (void)animateLabelForUpgrade {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    CGPoint point = self.center;
    [self addSubview:label];
    label.label.textColor = [UIColor colorWithRed:1.f green:1.f blue:0.f alpha:1.f];
    label.label.text = [NSString stringWithFormat:@"-%lld", [[ShopManager instance] priceForItemId:self.item.itemId type:self.item.type]];
    label.center = point;
    [label animate];
}
@end

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
#import "TrackUtils.h"

@implementation UpgradeView

- (IBAction)LvlButtonPressed:(id)sender {
    self.tempPrice = [[ShopManager instance] priceForItemId:self.item.itemId type:self.item.type];
    if ([UserData instance].currentScore >= self.cost) {
        [TrackUtils trackAction:self.item.itemId label:@"End"];
        [[UpgradeManager instance] attemptUpgrade:self.item];
    }
}


- (void)show:(ShopItem *)item {
    [[NSNotificationCenter defaultCenter]postNotificationName:UPGRADE_VIEW_OPEN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:UPGRADE_ATTEMPT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upgradeSuccess) name:UPGRADE_ATTEMPT_SUCCESS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upgradeFail) name:UPGRADE_ATTEMPT_FAIL_NOTIFICATION object:nil];
    [super show];
    self.item = item;
    [self refresh];
}

- (void)upgradeSuccess {
    [TrackUtils trackAction:@"UpgradeSuccess" label:@"End"];
    [self performSelector:@selector(animateLabelForUpgrade) withObject:nil afterDelay:7.6f];
    [[[UpgradeResultView alloc] init] showSuccess];
    
    [self checkMaxLevel:[self checkItemLevel]];
}

- (void)upgradeFail {
    [TrackUtils trackAction:@"UpgradeFail" label:@"End"];
    [[[UpgradeResultView alloc] init] showFail];
    [self performSelector:@selector(animateLabelForUpgrade) withObject:nil afterDelay:4.8f];
    
}
- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:sender];
}

- (IBAction)closeButtonPressed:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:UPGRADE_VIEW_CLOSED_NOTIFICATION object:nil];
    [self dismissed:self];
}

- (void)refresh {
    self.upgradeIcon.image = [UIImage imageNamed:self.item.imagePath];
    self.cost = [[ShopManager instance] priceForItemId:self.item.itemId type:self.item.type];
    self.currentExpLabel.text = [NSString stringWithFormat:@"%@",[Utils formatLongLongWithComma:[UserData instance].currentScore]];
    self.nextCostLabel.text = [NSString stringWithFormat:@"-%@",[Utils formatLongLongWithComma:self.cost]];
    long long tempResult = [UserData instance].currentScore;
    tempResult -= self.cost;
    self.afterCostLabel.text = [NSString stringWithFormat:@"%@",[Utils formatLongLongWithComma:tempResult]];
    
    self.lvlLabel.text = [NSString stringWithFormat:@"Lvl:%d", [self checkItemLevel]];
}

- (int)checkItemLevel {
    NSMutableDictionary *typeDictionary = [[UserData instance].gameDataDictionary objectForKey:[NSString stringWithFormat:@"%d", self.item.type]];
    return [[typeDictionary objectForKey:self.item.itemId]intValue];
}

- (void)checkMaxLevel:(int)lvl {
    if (lvl >= 100) {
        [TrackUtils trackAction:@"UpgradeMAXED" label:@"End"];
        [self dismissed:self];
    }
}
- (void)animateLabelForUpgrade {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    CGPoint point = self.center;
    [self addSubview:label];
    label.label.textColor = [UIColor colorWithRed:0.f green:.8f blue:0.8f alpha:1.f];
    label.label.text = [NSString stringWithFormat:@"-%lld", self.tempPrice];
    label.center = point;
    [label animateSlow];
}
@end

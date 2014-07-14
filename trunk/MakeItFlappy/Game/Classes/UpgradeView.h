//
//  UpgradeView.h
//  Make It Flappy
//
//  Created by MacCoder on 6/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibDialogView.h"
#import "UpgradeManager.h"
#import "Utils.h"
#import "UserData.h"

@interface UpgradeView : XibDialogView
@property (strong, nonatomic) IBOutlet UILabel *currentExpLabel;
@property (strong, nonatomic) IBOutlet UILabel *nextCostLabel;
@property (strong, nonatomic) IBOutlet UILabel *afterCostLabel;
@property (strong, nonatomic) IBOutlet UILabel *lvlLabel;
@property (nonatomic) ShopItem *item;
@property (nonatomic) long long cost;
@property (nonatomic) long long tempPrice;
@property (strong, nonatomic) IBOutlet UIImageView *upgradeIcon;

-(void)show:(ShopItem *)item;

@end
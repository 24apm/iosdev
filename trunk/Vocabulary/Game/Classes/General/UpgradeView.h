//
//  UpgradeView.h
//  Make It Flappy
//
//  Created by MacCoder on 6/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimatingDialogView.h"
#import "Utils.h"
#import "UserData.h"

@interface UpgradeView : AnimatingDialogView
@property (strong, nonatomic) IBOutlet UILabel *currentExpLabel;
@property (strong, nonatomic) IBOutlet UILabel *nextCostLabel;
@property (strong, nonatomic) IBOutlet UILabel *afterCostLabel;
@property (strong, nonatomic) IBOutlet UILabel *lvlLabel;
@property (nonatomic) long long cost;
@property (strong, nonatomic) IBOutlet UIImageView *upgradeIcon;

-(void)show;

@end

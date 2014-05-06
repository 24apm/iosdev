//
//  ConfirmMenu.h
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibDialogView.h"
#import "ButtonView.h"
#import "GameData.h"
#import "UserData.h"
#import "AnimatingDialogView.h"

#define CANCEL_BUTTON_PRESSED_NOTIFICATION @"CANCEL_BUTTON_PRESSED_NOTIFICATION"
#define BUY_POWER_CONFIRM_BUTTON_PRESSED_NOTIFICATION @"BUY_POWER_CONFIRM_BUTTON_PRESSED_NOTIFICATION"

@interface ConfirmMenu : AnimatingDialogView

@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *itemCost;
@property (strong, nonatomic) IBOutlet UILabel *Operation;
@property (strong, nonatomic) IBOutlet UILabel *currentCoin;
@property (strong, nonatomic) IBOutlet UILabel *result;

@property (nonatomic, strong) ButtonView *buttonView;
@property (nonatomic) int afterPay;
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (void)show:(ButtonView *)buttonView;

@end

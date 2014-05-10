//
//  CoinMenuView.h
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibDialogView.h"
#import "CoinView.h"
#import "UserData.h"
#import "AnimatingDialogView.h"
#import "TrackUtils.h"

#define PURCHASE_SUCCESS_NOTIFICATION @"PURCHASE_SUCCESS_NOTIFICATION"

@interface CoinMenuView : AnimatingDialogView

@property (strong, nonatomic) IBOutletCollection(CoinView) NSArray *coinViewCollection;

- (void)show;

@end

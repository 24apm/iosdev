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

@interface CoinMenuView : XibDialogView

@property (strong, nonatomic) IBOutletCollection(CoinView) NSArray *coinViewCollection;

- (void)show;

@end

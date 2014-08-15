//
//  BankDialogView.h
//  Weed
//
//  Created by MacCoder on 8/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VisitorData.h"
#import "BankData.h"

@interface BankVisitorData : VisitorData

@property (strong, nonatomic) BankData *bankData;

+ (BankVisitorData *)dummyData;

@end

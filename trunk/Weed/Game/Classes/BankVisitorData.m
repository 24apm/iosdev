//
//  BankDialogView.m
//  Weed
//
//  Created by MacCoder on 8/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BankVisitorData.h"

@implementation BankVisitorData

+ (BankVisitorData *)dummyData {
    BankVisitorData *data = [[BankVisitorData alloc] init];
    data.bankData = [BankData dummyData];
    data.imagePath = @"ToiletRush120.png";
    data.name = @"Bank Finance";
    data.occupation = @"Borrow";
    return data;
}

@end

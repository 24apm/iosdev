//
//  BankData.m
//  Weed
//
//  Created by MacCoder on 8/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BankData.h"
#import "Utils.h"
#import "LevelManager.h"

@implementation BankData

+ (BankData *)defaultData {
    BankData *bankData = [[BankData alloc] init];
    bankData.id = 0;
    bankData.cost = 10;
    bankData.bankData = nil;
    bankData.unitSize = 1;
    return bankData;
}

+ (BankData *)dummyData {
    BankData *bankData = [[BankData alloc] init];
    bankData.id = 0;
    bankData.bankData = nil;
    bankData.unitSize = [[LevelManager instance] generateHouseSize];
    bankData.cost = [[LevelManager instance] generateHouseCost:bankData.unitSize];
    return bankData;
}


@end

//
//  BankData.h
//  Weed
//
//  Created by MacCoder on 8/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankData : NSObject

@property (strong, nonatomic) BankData *bankData;
@property (nonatomic) int id;
@property (nonatomic) long long cost;
@property (nonatomic) int unitSize;

+ (BankData *)defaultData;
+ (BankData *)dummyData;

@end

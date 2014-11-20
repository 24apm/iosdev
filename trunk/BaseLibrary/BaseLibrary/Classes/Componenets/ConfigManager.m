//
//  GameConstantBase.m
//  BaseLibrary
//
//  Created by MacCoder on 11/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ConfigManager.h"

@implementation ConfigManager

+ (ConfigManager *)instance {
    static ConfigManager *instance = nil;
    if (!instance) {
        instance = [[ConfigManager alloc] init];
    }
    return instance;
}

@end

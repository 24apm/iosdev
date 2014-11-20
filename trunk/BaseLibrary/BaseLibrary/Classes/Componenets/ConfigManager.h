//
//  GameConstantBase.h
//  BaseLibrary
//
//  Created by MacCoder on 11/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigManager : NSObject

+ (ConfigManager *)instance;

@property (nonatomic) CGFloat ipadScale;

@end

//
//  NumberManager.h
//  NumberGame
//
//  Created by MacCoder on 2/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberManager : NSObject

+ (NumberManager *)instance;
- (NSDictionary *)generateLevel;
- (BOOL)checkAlgebra:(NSArray *)algrebra targetValue:(float)targetValue;
- (NSArray *)generateAnswerFor:(int)input;

@end

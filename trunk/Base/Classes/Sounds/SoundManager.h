//
//  SoundManagerBase.h
//  Base
//
//  Created by MacCoder on 2/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundManager : NSObject

+ (SoundManager *)instance;
- (void)play:(NSString *)fileName;
- (void)play:(NSString *)fileName repeat:(BOOL)repeat;
- (void)prepare:(NSString *)fileName count:(int)count;
- (void)stop:(NSString *)fileName;
- (NSTimeInterval)duration:(NSString *)fileName;

@end

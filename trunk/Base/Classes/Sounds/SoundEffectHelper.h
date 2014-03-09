//
//  SoundEffectHelper.h
//  Base
//
//  Created by MacCoder on 2/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundEffectHelper : NSObject

- (id)initAVSoundNamed:(NSString *)fileName withCount:(int)count;
- (void)play;
- (void)stop;
- (NSTimeInterval)duration;

@end

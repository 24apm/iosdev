//
//  SoundEffect.h
//  Base
//
//  Created by MacCoder on 6/1/13.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundEffect : NSObject

@property (nonatomic) NSInteger numberOfLoops;

- (id)initAVSoundNamed:(NSString *)fileName;
- (void)play;
- (void)stop;
- (NSTimeInterval)duration;

@end

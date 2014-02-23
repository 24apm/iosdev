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

- (id)initAVSoundNamed:(NSString *)fileName;
- (void)play;
- (NSTimeInterval)duration;

@end

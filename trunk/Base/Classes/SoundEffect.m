//
//  SoundEffect.m
//  Base
//
//  Created by MacCoder on 6/1/13.
//
//

#import "SoundEffect.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>

@interface SoundEffect()

@property (nonatomic, retain) AVAudioPlayer *audio;

@end

@implementation SoundEffect

- (id)initAVSoundNamed:(NSString *)fileName {
    self = [super init];
    if (self) {
        NSString *fileExt = [fileName pathExtension];
        if (!fileExt || fileExt.length <= 0) {
            fileExt = @"caf";
        }
        fileName = [fileName stringByDeletingPathExtension];
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt];
        if (path) {
            self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
            [self.audio prepareToPlay];
        } else {
            NSLog(@"File not found: %@", fileName);
        }
    }
    return self;
}

- (NSTimeInterval)duration {
    return self.audio.duration;
}

- (void)play {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.audio play];
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
}

@end

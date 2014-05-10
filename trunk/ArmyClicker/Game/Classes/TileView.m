//
//  TileView.m
//  2048
//
//  Created by MacCoder on 4/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "TileView.h"
#import "GameConstants.h"

@interface TileView()

@end

@implementation TileView

- (id)init {
    self = [super init];
    if (self) {
        self.tileButton.hidden = NO;
        self.label.hidden = NO;
        self.isMergeable = YES;
        self.isMerged = NO;
        //self.label.strokeColor = [UIColor blackColor];
        //self.label.strokeSize = 2.f * IPAD_SCALE;
    }
    return self;
}

- (void)blitBackgroundImage {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.label.hidden = YES;
        self.blitImageView.hidden = YES;
        
        self.layer.cornerRadius = self.height / 5.f;
        self.clipsToBounds = YES;
        UIImage *blitImage = [self blit];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.blitImageView.image = blitImage;
            
            self.layer.cornerRadius = 0.f;
            self.clipsToBounds = NO;
            
            self.label.hidden = NO;
            self.blitImageView.hidden = NO;
            self.backgroundColor = [UIColor clearColor];
        });
    });
    
    

}

- (IBAction)buttonPressed:(UIButton *)sender {
    NSDictionary *aDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 self, @"pressedTile",
                                 nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MAX_LEVEL_TILE_PRESSED object:nil userInfo:aDictionary];
    
}

- (void)setCurrentValue:(int)numberLevel {
    _currentValue = numberLevel;
}

- (void)animateMergedTile {
    [self.layer removeAnimationForKey:@"animateMerge"];
    
    CAKeyframeAnimation *scaleIn = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleIn.values = @[@(1.f),@(1.2f),@(1.0f)];
    scaleIn.keyTimes = @[@(0.0f),@(0.7f),@(0.9f)];
    
    CAAnimationGroup *animateGroup = [CAAnimationGroup animation];
    animateGroup.animations = [NSArray arrayWithObjects:scaleIn, nil];
    animateGroup.duration = 0.2f;
    [self.layer addAnimation:animateGroup forKey:@"animateMerge"];
    [self performSelector:@selector(updateToRealLabel) withObject:nil afterDelay:animateGroup.duration / 2.f];
}

- (void)updateToRealLabel {
    self.label.text = [NSString stringWithFormat:@"%d",self.currentValue];
    [self updateStyle];
}

- (void)updateStyle {
    self.label.textColor = [UIColor whiteColor];
    switch (self.currentValue) {
        case 2:
            self.backgroundColor = [UIColor colorWithHue:28.f/360.f saturation:0.06f brightness:0.94f alpha:1.0f];
            self.label.textColor = [UIColor blackColor];
            break;
            
        case 4:
            self.backgroundColor = [UIColor colorWithHue:37.f/360.f saturation:0.11f brightness:0.92f alpha:1.0f];
            self.label.textColor = [UIColor blackColor];
            break;
            
        case 8:
            self.backgroundColor = [UIColor colorWithHue:25.f/360.f saturation:0.37f brightness:0.96f alpha:1.0f];
            break;
            
        case 16:
            self.backgroundColor = [UIColor colorWithHue:20.f/360.f saturation:0.47f brightness:0.93f alpha:1.0f];
            break;
            
        case 32:
            self.backgroundColor = [UIColor colorWithHue:9.f/360.f saturation:0.47f brightness:0.96f alpha:1.0f];
            break;
            
        case 64:
            self.backgroundColor = [UIColor colorWithHue:7.f/360.f saturation:0.57f brightness:0.93f alpha:1.0f];
            break;
            
        case 128:
            self.backgroundColor = [UIColor colorWithHue:45.f/360.f saturation:0.49f brightness:0.96f alpha:1.0f];
            break;
            
        case 256:
            self.backgroundColor = [UIColor colorWithHue:45.f/360.f saturation:0.47f brightness:0.95f alpha:1.0f];
            break;
            
        case 512:
            self.backgroundColor = [UIColor colorWithHue:45.f/360.f saturation:0.50f brightness:0.93f alpha:1.0f];
            break;
            
        case 1024:
            self.backgroundColor = [UIColor colorWithHue:45.f/360.f saturation:0.55f brightness:0.91f alpha:1.0f];
            break;
            
        case 2048:
            self.backgroundColor = [UIColor colorWithHue:46.f/360.f saturation:0.72f brightness:0.93f alpha:1.0f];
            break;
            
        case 4096:
            self.backgroundColor = [UIColor colorWithHue:130.f/360.f saturation:0.72f brightness:0.93f alpha:1.0f];
            break;
            
        case 8192:
            self.backgroundColor = [UIColor colorWithHue:180.f/360.f saturation:0.72f brightness:0.93f alpha:1.0f];
            break;
            
        case 16384:
            self.backgroundColor = [UIColor colorWithHue:235.f/360.f saturation:0.72f brightness:0.93f alpha:1.0f];
            break;
            
        case 32768:
            self.backgroundColor = [UIColor colorWithHue:270.f/360.f saturation:0.72f brightness:0.93f alpha:1.0f];
            break;
            
        case 65536:
            self.backgroundColor = [UIColor colorWithHue:325.f/360.f saturation:0.72f brightness:0.93f alpha:1.0f];
            break;
            
        default:
            break;
    }
    self.imgView.animationDuration = 0.5f;
    self.imgView.animationRepeatCount = 0;
    [self.imgView startAnimating];
    [self addSubview: self.imgView];
    // self.imgView.image = [self.imgView.animationImages firstObject];
    //self.backgroundColor = [UIColor redColor];
    [self blitBackgroundImage];
}

@end

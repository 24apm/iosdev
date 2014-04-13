//
//  TileView.m
//  2048
//
//  Created by MacCoder on 4/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "TileView.h"

@implementation TileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
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
    switch (self.currentValue) {
        case 2:
            self.backgroundColor = [UIColor whiteColor];
            break;
        case 4:
            self.backgroundColor = [UIColor grayColor];
            break;
        case 8:
            self.backgroundColor = [UIColor greenColor];
            break;
        case 16:
            self.backgroundColor = [UIColor blueColor];
            break;
        case 32:
            self.backgroundColor = [UIColor brownColor];
            break;
        case 64:
            self.backgroundColor = [UIColor yellowColor];
            break;
        case 128:
            self.backgroundColor = [UIColor lightGrayColor];
            break;
        case 256:
            self.backgroundColor = [UIColor purpleColor];
            break;
        case 512:
            self.backgroundColor = [UIColor orangeColor];
            break;
        case 1024:
            self.backgroundColor = [UIColor greenColor];
            break;
        case 2048:
            self.backgroundColor = [UIColor redColor];
            break;
        case 4096:
            self.backgroundColor = [UIColor yellowColor];
            break;
        default:
            break;
    }
}

@end

//
//  TileView.m
//  2048
//
//  Created by MacCoder on 4/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "TileView.h"

@interface TileView()

@end

@implementation TileView

- (id)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = self.height / 5.f;
        self.clipsToBounds = YES;
        self.tileButton.hidden = NO;
        self.label.hidden = YES;
        self.isMergeable = YES;
        self.isMerged = NO;
    }
    return self;
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
    switch (self.currentValue) {
        case 2:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier0"],
                                            [UIImage imageNamed:@"tier0-2"], nil];
            break;
        case 4:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier1"],
                                            [UIImage imageNamed:@"tier1-2"], nil];
            
            break;
        case 8:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier2"],
                                            [UIImage imageNamed:@"tier2-2"], nil];
            
            break;
        case 16:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier3"],
                                            [UIImage imageNamed:@"tier3-2"], nil];
            
            break;
        case 32:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier4"],
                                            [UIImage imageNamed:@"tier4-2"], nil];
            
            break;
        case 64:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier5"],
                                            [UIImage imageNamed:@"tier5-2"], nil];
            
            break;
        case 128:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier6"],
                                            [UIImage imageNamed:@"tier6-2"], nil];
            
            break;
        case 256:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier7"],
                                            [UIImage imageNamed:@"tier7-2"], nil];
            
            break;
        case 512:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier8"],
                                            [UIImage imageNamed:@"tier8-2"], nil];
            
            break;
        case 1024:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier9"],
                                            [UIImage imageNamed:@"tier9-2"], nil];
            
            break;
        case 2048:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier10"],
                                            [UIImage imageNamed:@"tier10-2"], nil];
            
            break;
        case 4096:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier11"],
                                            [UIImage imageNamed:@"tier11-2"], nil];
            
            break;
        case 8192:
            self.imgView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"tier12"],
                                            [UIImage imageNamed:@"tier12-2"], nil];
            
            self.isMergeable = NO;
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
}

@end

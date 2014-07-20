//
//  UnitBaseView.m
//  Evolution
//
//  Created by MacCoder on 5/31/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UnitBaseView.h"
#import "GameLoopTimer.h"
#import "Utils.h"

#define THRESHOLD 3.f

@interface UnitBaseView()

@property (nonatomic) CGPoint targetPosition;
@property (nonatomic) CGFloat startTime;

@end

@implementation UnitBaseView

- (void)step {
    switch (self.state) {
        case UnitViewStateAnimateRunning:   // x1
            [self animateRunning];
            break;
        case UnitViewStateRunning:          // x999
            [self doStep];
            break;
        case UnitViewStateAnimateIdle:      // x1
            [self animateIdle];
            break;
        case UnitViewStateIdle:             // x999
            [self doIdle];
            break;
        default:
            break;
    }
}

- (void)doIdle {
    if (CACurrentMediaTime() > self.idleTime) {
        [self generateTarget];
        self.state = UnitViewStateAnimateRunning;
    }
}

- (void)animateIdle {
    self.characterImageView.animationDuration = 1.f;
    self.characterImageView.animationImages = [self idleImages];
    self.characterImageView.animationRepeatCount = HUGE_VALF;
    [self.characterImageView startAnimating];
    
    
    self.idleTime = CACurrentMediaTime() + self.idleDuration;
    self.state = UnitViewStateIdle;
}

- (void)animateRunning{
    self.characterImageView.animationDuration = 1.f;
    self.characterImageView.animationImages = [self runningImages];
    self.characterImageView.animationRepeatCount = HUGE_VALF;
    [self.characterImageView startAnimating];
    
    self.state = UnitViewStateRunning;
}

- (void)doStep {
    float unitX = 1.f;
    float unitY = 0.f;
    
    float xNew = self.center.x;
    float yNew = self.center.y;
    float speed = self.speed;
    
    if (self.targetPosition.x > self.center.x) {
        xNew += unitX * speed;
    } else {
        xNew -= unitX * speed;
    }
    
    if (self.targetPosition.y > self.center.y) {
        yNew += unitY * speed;
    } else {
        yNew -= unitY * speed;
    }
    
    self.center = CGPointMake(xNew, yNew);
    
    self.layer.zPosition = self.y + self.height;
    
    if ([self isWithinThreshold]) {
        [self generateTarget];
        self.state = UnitViewStateAnimateRunning;
    }
}

- (BOOL)isWithinThreshold {
    if (fabsf(self.targetPosition.x - self.center.x) < THRESHOLD) {
        return YES;
    } else {
        return NO;
    }
}

- (void)generateTarget {
    float targetRandX = arc4random() % (int)self.superview.width;
    self.targetPosition = CGPointMake(targetRandX, self.center.y);
//    [self updateOrientation];
    self.speed = [Utils randBetweenMin:0.8f max:1.2f];
}

- (void)updateOrientation {
    if (self.targetPosition.x > self.center.x) {
        self.transform = CGAffineTransformMakeScale(1.f, 1.f);
    } else {
        self.transform = CGAffineTransformMakeScale(-1.f, 1.f);
    }
}

- (IBAction)buttonPressed:(id)sender {
    [self doPressed];
}

- (NSArray *)idleImages {
    // override
    return nil;
}

- (NSArray *)runningImages {
    // override
    return nil;
}

- (void)doPressed {
    // override
}

- (void)removeFromSuperview {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
}

@end

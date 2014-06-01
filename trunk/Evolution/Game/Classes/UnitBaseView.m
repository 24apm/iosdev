//
//  UnitBaseView.m
//  Evolution
//
//  Created by MacCoder on 5/31/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UnitBaseView.h"

#define THRESHOLD 3.f


@interface UnitBaseView()

@property (nonatomic) CFTimeInterval idleTime;
@property (nonatomic) CGPoint targetPosition;
@property (nonatomic) CGFloat startTime;

@end

@implementation UnitBaseView

- (id)init {
    self = [super init];
    if (self) {
        self.state = UnitViewStateAnimateRunning;
    }
    return self;
}

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
    float degree = atanf((self.targetPosition.y - self.center.y) /
                         (self.targetPosition.x - self.center.x));
    
    float unitX = fabs(cosf(degree));
    float unitY = fabs(sinf(degree));
    
    float xNew = self.center.x;
    float yNew = self.center.y;
    
    if (self.targetPosition.x > self.center.x) {
        xNew += unitX;
    } else {
        xNew -= unitX;
    }
    
    if (self.targetPosition.y > self.center.y) {
        yNew += unitY;
    } else {
        yNew -= unitY;
    }
    
    self.center = CGPointMake(xNew, yNew);
    
    if ([self isWithinThreshold]) {
        self.state = UnitViewStateAnimateIdle;
    }
}

- (BOOL)isWithinThreshold {
    if (fabsf(self.targetPosition.x - self.center.x) < THRESHOLD &&
        fabsf(self.targetPosition.y - self.center.y) < THRESHOLD) {
        return YES;
    } else {
        return NO;
    }
}

- (void)generateTarget {
    float targetRandX = arc4random() % (int)self.superview.width;
    float targetRandY = arc4random() % (int)self.superview.height;
    self.targetPosition = CGPointMake(targetRandX, targetRandY);
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
    [super removeFromSuperview];
}


@end

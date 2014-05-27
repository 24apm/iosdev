//
//  UnitView.m
//  Evolution
//
//  Created by MacCoder on 5/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UnitView.h"

#define THRESHOLD 3.f

@implementation UnitView

- (void)step {
    if (self.isRunning) {
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
            self.isRunning = NO;
            [self performSelector:@selector(generateTarget) withObject:nil afterDelay:0.5f];
        }
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
    self.isRunning = YES;
}

- (IBAction)buttonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:UNIT_VIEW_TAPPED object:self];
}

- (void)removeFromSuperview {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super removeFromSuperview];
}

@end

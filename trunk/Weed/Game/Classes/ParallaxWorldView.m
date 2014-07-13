//
//  ParallaxWorldView.m
//  Weed
//
//  Created by MacCoder on 7/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ParallaxWorldView.h"
#import "ParallaxBackgroundView.h"
#import "ParallaxForegroundView.h"
#import "Utils.h"

@interface ParallaxWorldView()

@property (nonatomic, strong) NSMutableArray *parallaxViews;
@property (nonatomic, strong) UIView *scrollView;
@property (nonatomic) CGFloat lastScreenXOffset;

@end

@implementation ParallaxWorldView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.parallaxViews = [NSMutableArray array];
    

    ParallaxBackgroundView *backgroundView = [[ParallaxBackgroundView alloc] init];
    [self.parallaxViews addObject:backgroundView];
    
    ParallaxForegroundView *foregroundView = [[ParallaxForegroundView alloc] init];
    [self.parallaxViews addObject:foregroundView];
    
    self.scrollView = [[UIView alloc] init];
    [self addSubview:self.scrollView];

    self.scrollView.frame = foregroundView.frame;
    self.scrollView.autoresizingMask = foregroundView.autoresizingMask;
    
    for (UIView *view in self.parallaxViews) {
        [self addSubview:view];
    }
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    
    [self addGestureRecognizer:panGesture];

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [self overlapHitTest:point withEvent:event];
}

-(IBAction)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.lastScreenXOffset = self.scrollView.x;
        
        // Cancel pervious animation by overriding it with another very short animation
        CGFloat percentageOffsetX = self.scrollView.x / (self.scrollView.width - self.width);
        [UIView animateWithDuration:0.001f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            for (UIView *view in self.parallaxViews) {
                view.x = -(view.width - self.width) * percentageOffsetX ;
            }
        } completion:nil];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // drag
        CGPoint translation = [recognizer translationInView:self];
        self.scrollView.x = self.lastScreenXOffset - translation.x;

        if (self.scrollView.x > self.scrollView.width - self.width) {
            self.scrollView.x = self.scrollView.width - self.width;
        }
        
        if (self.scrollView.x < 0) {
            self.scrollView.x = 0;
        }
        
        CGFloat percentageOffsetX = self.scrollView.x / (self.scrollView.width - self.width);
        
        for (UIView *view in self.parallaxViews) {
            view.x = -(view.width - self.width) * percentageOffsetX ;
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // animate upon letting go of finger
        CGPoint velocity = [recognizer velocityInView:self];
        CGFloat cappedVelocity = self.width * 2.f;
        if (velocity.x < -cappedVelocity) {
            velocity.x = -cappedVelocity;
        }
        
        if (velocity.x > cappedVelocity) {
            velocity.x = cappedVelocity;
        }
        
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        
        float slideFactor = 0.5 * slideMult; // Increase for more of a slide

        CGFloat transformDifference = (velocity.x * slideFactor);
        self.scrollView.x -= transformDifference;
        
        CGFloat duration = slideFactor;
        CGFloat xOverflowed;
        
        if (self.scrollView.x > self.scrollView.width - self.width) {
            xOverflowed = self.scrollView.x - self.scrollView.width - self.width;
            duration *= (xOverflowed - transformDifference) / transformDifference;
            self.scrollView.x = self.scrollView.width - self.width;
        }
        
        if (self.scrollView.x < 0) {
            xOverflowed = 0 - self.scrollView.x;
            duration *= (xOverflowed - transformDifference) / transformDifference;

            self.scrollView.x = 0;
        }
        duration =  fabsf(CLAMP(duration, 0.5f, 1.0f));

        CGFloat percentageOffsetX = self.scrollView.x / (self.scrollView.width - self.width);

        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            for (UIView *view in self.parallaxViews) {
                view.x = -(view.width - self.width) * percentageOffsetX ;
            }
        } completion:nil];
    }
}

@end

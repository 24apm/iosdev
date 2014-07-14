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
#import "CustomGameLoopTimer.h"

@interface ParallaxWorldView()

@property (strong, nonatomic) NSMutableArray *parallaxViews;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic) CGFloat lastScreenXOffset;
@property (nonatomic) CGPoint velocity;
@property (nonatomic) CGPoint lastSnapShotVelocity;

@property (nonatomic) double lastTime;

@property (strong, nonatomic) ParallaxBackgroundView *backgroundView;
@property (strong, nonatomic) ParallaxForegroundView *foregroundView;

@end

@implementation ParallaxWorldView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parallaxViews = [NSMutableArray array];
        
        self.backgroundView = [[ParallaxBackgroundView alloc] init];
        [self.parallaxViews addObject:self.backgroundView];
        
        self.foregroundView = [[ParallaxForegroundView alloc] init];
        [self.parallaxViews addObject:self.foregroundView];
        self.scrollView = [[UIScrollView alloc] init];

        self.scrollView.frame = self.frame;
        self.scrollView.contentSize = self.foregroundView.frame.size;
        self.scrollView.autoresizingMask = self.foregroundView.
        autoresizingMask;
        self.scrollView.delegate = self;
        self.scrollView.bounces = NO;
        
        for (UIView *view in self.parallaxViews) {
            [self addSubview:view];
        }
        [self addSubview:self.scrollView];
        
    }
    return self;
}

- (void)setup {
    [self.foregroundView setup];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat percentageOffsetX = self.scrollView.contentOffset.x / (self.scrollView.contentSize.width - self.scrollView.width);
    
    for (UIView *view in self.parallaxViews) {
        view.x = -(view.width - self.scrollView.width) * percentageOffsetX ;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [self hitTest:self.backgroundView point:point withEvent:event];
    if (view) {
        return view;
    } else {
        return [super hitTest:point withEvent:event];
    }
}

- (UIView *)hitTest:(UIView *)someView point:(CGPoint)point withEvent:(UIEvent *)event {
    if ([someView isKindOfClass:[UIButton class]]) {
        CGPoint pointInButton = [someView convertPoint:point fromView:self];
        if ([someView pointInside:pointInButton withEvent:event]) {
            return someView;
        }
    }
    
    UIView *hitView;
    
    for (UIView *view in someView.subviews) {
        hitView = [self hitTest:view point:point withEvent:event];
        if (hitView) {
            return hitView;
        }
    }
    
    return nil;
}

@end

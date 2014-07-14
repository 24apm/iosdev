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
#import "UserData.h"

@interface ParallaxWorldView()

@property (strong, nonatomic) NSMutableArray *parallaxViews;
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
        [self.containerView addSubview:self.backgroundView];

        self.foregroundView = [[ParallaxForegroundView alloc] init];
        [self.containerView addSubview:self.foregroundView];

        self.foregroundView.scrollView.delegate = self;
   
    }
    return self;
}

- (void)setup {
    [self.backgroundView setup];
    [self.foregroundView setup];
    self.coinLabel.text = [NSString stringWithFormat:@"%lld", [UserData instance].coin];
    [[UserData instance] addObserver:self forKeyPath:@"coin" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"coin"]) {
        id newValue = [object valueForKeyPath:keyPath];
        self.coinLabel.text = [NSString stringWithFormat:@"%d", [newValue integerValue]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat percentageOffsetX = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.width);
    
    for (UIView *view in self.parallaxViews) {
        view.x = -(view.width - scrollView.width) * percentageOffsetX ;
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

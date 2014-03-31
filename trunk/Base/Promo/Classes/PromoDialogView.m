//
//  PromoDialogView.m
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PromoDialogView.h"
#import "PromoManager.h"
#import "AnimUtil.h"
#import "Utils.h"

@interface PromoDialogView()

@property (strong, nonatomic) NSArray *promoArray;

@end

@implementation PromoDialogView

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(promoIconCallback:) name:PROMO_ICON_CALLBACK object:nil];
    }
    return self;
}

- (void)show {
    [super show];
    self.overlay.alpha = 0.f;
    self.headerLabel.alpha = 0.f;
    self.closeButton.alpha = 0.f;
    [self setupPromos];
    [self animateBackground];
    [self performSelector:@selector(animateFakePromos) withObject:nil afterDelay:0.4f];
    [self performSelector:@selector(animatePromos) withObject:nil afterDelay:0.8f];
}

- (void)setupPromos {
    self.promoArray = [[PromoManager instance] nextPromoSetWithSize:3];
    for (int i = 0; i < self.promoArray.count; i++) {
        PromoIconView *promoIconView = [self.promoIcons objectAtIndex:i];
        [promoIconView setupWithPromoGameData:[self.promoArray objectAtIndex:i]];
        promoIconView.alpha = 0.f;
    }
}

- (void)promoIconCallback:(NSNotification *)notification {
    PromoIconView *promoIconView = notification.object;
    [[PromoManager instance] promoPressed:promoIconView.promoGameData];
    [self dismissed];
}

- (void)dismissed {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:self];
}

#pragma mark - Animations

- (void)animateBackground {
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
    fadeIn.duration = 0.3f;
    fadeIn.removedOnCompletion = NO;
    fadeIn.fillMode = kCAFillModeForwards;
    [self.overlay.layer addAnimation:fadeIn forKey:@"fadeIn"];
}

- (void)animateFakePromos {
    float delay = 0.f;
    
    for (int i = 0; i < 3; i++) {
        delay += 0.1f;
        PromoIconView *promoIconView = [self.promoIcons objectAtIndex:i];
        [self performSelector:@selector(animateFakePromo:) withObject:promoIconView afterDelay:delay];
    }
}

- (void)animateFakePromo:(PromoIconView *)promoIconView {
    UIImageView *fakePromo = [[UIImageView alloc] initWithImage:promoIconView.iconView.image];
    [self addSubview:fakePromo];
    fakePromo.frame = promoIconView.frame;
    fakePromo.center = self.center;
    fakePromo.alpha = 0.f;
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
    fakePromo.alpha = 1.0f;
    
    CABasicAnimation *scaleIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleIn.toValue = @(1.0f);
    
    CGPoint toPoint;
    toPoint.x = [Utils randBetweenMin:0.f max:self.width];
    toPoint.y = -promoIconView.height;
    
    CABasicAnimation *position = [CABasicAnimation animationWithKeyPath:@"position"];
    position.toValue = [NSNumber valueWithCGPoint:toPoint];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0f];
    rotationAnimation.duration = 0.4f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;

    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    [groupAnimation setAnimations:[NSArray arrayWithObjects:position, scaleIn, rotationAnimation, fadeIn, nil]];
    [groupAnimation setDuration:0.3f];
    [groupAnimation setRemovedOnCompletion:NO];
    [groupAnimation setFillMode:kCAFillModeForwards];
    [fakePromo.layer addAnimation:groupAnimation forKey:@"animateIn"];
    [self performSelector:@selector(removeView:) withObject:fakePromo afterDelay:groupAnimation.duration + 0.1f];

}

- (void)removeView:(UIView *)view {
    [view removeFromSuperview];
}

- (void)animatePromos {
    float delay = 0.f;
    
    delay += 0.3f;
    [self performSelector:@selector(animateIn:) withObject:self.headerLabel afterDelay:delay];
    
    for (int i = 0; i < self.promoIcons.count; i++) {
        PromoIconView *promoIconView = [self.promoIcons objectAtIndex:i];
        
        delay += 0.3f;
        [self performSelector:@selector(animateInAndWiggle:) withObject:promoIconView afterDelay:delay];
    }
    
    delay += 0.5f;
    [self performSelector:@selector(animateIn:) withObject:self.closeButton afterDelay:delay];
}

- (void)animateInAndWiggle:(UIView *)view {
    [self animateIn:view];
    [AnimUtil wobble:view duration:0.3f angle:M_PI/128.f repeatCount:HUGE_VAL];
}


- (void)animateIn:(UIView *)view {
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
    view.alpha = 1.0f;

    CAKeyframeAnimation *scaleIn = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleIn.values = @[@(0.0f),@(1.4f),@(1.0f)];
    scaleIn.keyTimes = @[@(0.0f),@(0.7f),@(0.9f)];
    
    CGPoint fromPoint = view.center;
    CGPoint toPoint = view.center;
    
    fromPoint.y = -view.height;
    view.center = fromPoint;
    
    NSArray *positionValues = [NSArray arrayWithObjects:
                               [NSNumber valueWithCGPoint:CGPointMake(toPoint.x, toPoint.y * 0.0f)],
                               [NSNumber valueWithCGPoint:CGPointMake(toPoint.x, toPoint.y * 1.2f)],
                               [NSNumber valueWithCGPoint:CGPointMake(toPoint.x, toPoint.y * 1.0f)],
                               nil];
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    position.values = positionValues;
    
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    [groupAnimation setAnimations:[NSArray arrayWithObjects:fadeIn, scaleIn, position, nil]];
    [groupAnimation setDuration:.3f];
    [groupAnimation setRemovedOnCompletion:NO];
    [groupAnimation setFillMode:kCAFillModeForwards];
    [view.layer addAnimation:groupAnimation forKey:@"animateIn"];
    
    view.alpha = 1.0f;
    view.center = toPoint;

}

@end

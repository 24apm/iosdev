//
//  GameLayoutView.m
//  SequenceGame
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimUtil.h"
#import "GameLayoutView.h"
#import "GameManager.h"
#import "SoundManager.h"
#import "GameConstants.h"
#import "InGameMessageView.h"

@interface GameLayoutView()

@property (nonatomic, strong) InGameMessageView *messageView;

@end

@implementation GameLayoutView

- (IBAction)leftButtonPressed:(UIButton *)sender {
    [self performSelector:@selector(leftPressed) withObject:nil afterDelay:0.05f];
    [[SoundManager instance]play:SOUND_EFFECT_POP];
    [self animateWeapon:UserInputDefend];
}

- (void)leftPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GAME_LAYOUT_VIEW_LEFT_BUTTON_PRESSED object:nil];
}

- (IBAction)rightButtonPressed:(UIButton *)sender {
    [self performSelector:@selector(rightPressed) withObject:nil afterDelay:0.05f];

    [[SoundManager instance] play:SOUND_EFFECT_POP];
    [self animateWeapon:UserInputAttack];
}

- (void)rightPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GAME_LAYOUT_VIEW_RIGHT_BUTTON_PRESSED object:nil];
}

- (void)updateUnitViews:(NSArray *)visibleUnits {
    for (int i = 0; i < self.imagePlaceHolder.count; i++) {
        NSString *imagePath;
        if (i < visibleUnits.count) {
            imagePath = ((MonsterData *)[visibleUnits objectAtIndex:i]).imagePath;
        } else {
            imagePath = nil;
        }
        MonsterView *monsterView = [self.imagePlaceHolder objectAtIndex:i];
        [monsterView refreshImage:imagePath];
    }
}

#pragma mark - Animation

- (void)animateWeapon:(UserInput)userInput {
    [self animateWeaponType:[[GameManager instance] imagePathForUserInput:userInput]];
}

- (void)animateWeaponType:(NSString *)imagePath {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagePath]];
    [self addSubview:imageView];
    
    imageView.frame = [self.attackView.superview convertRect:self.attackView.frame toView:self];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.alpha = 1.0f;
    } completion:^ (BOOL completed) {
        [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            imageView.alpha = 0.0f;
        } completion:^ (BOOL completed) {
            [imageView removeFromSuperview];
        }];
    }];
}

- (void)animateMonsterScaledIn:(UIView *)view {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[view blit]];
    [self addSubview:imageView];
    
    imageView.frame = [view.superview convertRect:view.frame toView:self];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.transform = CGAffineTransformMakeScale(8.f, 8.f);
        imageView.alpha = 1.0f;
    } completion:^ (BOOL completed) {
        [UIView animateWithDuration:0.3f delay:2.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            imageView.alpha = 0.0f;
            imageView.transform = CGAffineTransformMakeScale(10.f, 10.f);
        } completion:^ (BOOL completed) {
            [imageView removeFromSuperview];
        }];
    }];
}

- (void)animate:(MonsterView *)fromView toPoint:(CGPoint)toPoint {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:fromView.imageView.image];
    [self addSubview:imageView];
    imageView.frame = [fromView.superview convertRect:fromView.frame toView:self];
    
    CABasicAnimation *bubbleFadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    bubbleFadeIn.fromValue = [NSNumber numberWithFloat:1.0f];
    bubbleFadeIn.toValue = [NSNumber numberWithFloat:0.0f];
    
    float scaleRand = [Utils randBetweenMinInt:0 max:8];
    CABasicAnimation *bubbleExplode = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bubbleExplode.toValue = [NSNumber numberWithFloat:scaleRand];
    
    CABasicAnimation *bubblePosition = [CABasicAnimation animationWithKeyPath:@"position"];
    bubblePosition.toValue = [NSNumber valueWithCGPoint:toPoint];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0f];
    rotationAnimation.duration = 0.2f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;
    
    CAAnimationGroup *bubbleAnims = [CAAnimationGroup animation];
    [bubbleAnims setAnimations:[NSArray arrayWithObjects:bubbleFadeIn, bubbleExplode, bubblePosition, rotationAnimation, nil]];
    [bubbleAnims setDuration:0.5f];
    [bubbleAnims setRemovedOnCompletion:NO];
    [bubbleAnims setFillMode:kCAFillModeForwards];
    [imageView.layer addAnimation:bubbleAnims forKey:nil];
    
    [self performSelector:@selector(removeView:) withObject:imageView afterDelay:bubbleAnims.duration + 0.1f];
}

- (void)removeView:(UIView *)view {
    [view removeFromSuperview];
}

- (void)animatePopFrontUnit {
    NSArray *xPositions = @[@(self.width), @(-self.width)];
    float x = [[xPositions randomObject] floatValue];
    float y = [Utils randBetweenMinInt:0 max:self.height];
    
    [self animate:[self.imagePlaceHolder objectAtIndex:0] toPoint:CGPointMake(x,y)];
}

- (void)wobbleUnits {
    for (int i = 0; i < self.imagePlaceHolder.count; i++) {
        [AnimUtil wobble:[self.imagePlaceHolder objectAtIndex:i] duration:0.5f angle:M_PI/128.f repeatCount:HUGE_VAL];
    }
}

- (void)removeWobbleUnits {
    for (int i = 0; i < self.imagePlaceHolder.count; i++) {
        UIView *unit = [self.imagePlaceHolder objectAtIndex:i];
        [unit.layer removeAllAnimations];
    }
}

- (void)shakeScreen {
    [AnimUtil wobble:self duration:0.1f angle:M_PI/128.f repeatCount:2];
}

- (void)showMessageView:(NSString *)text {
    if (!self.messageView) {
        self.messageView = [[InGameMessageView alloc] init];
        [self addSubview:self.messageView];
        self.messageView.frame = self.frame;
        self.messageView.hidden = YES;
    }
    [self bringSubviewToFront:self.messageView];
    [self.messageView show:text];
}

- (void)showMessageViewWithImage:(NSString *)imageName {
    if (!self.messageView) {
        self.messageView = [[InGameMessageView alloc] init];
        [self addSubview:self.messageView];
        self.messageView.frame = self.frame;
        self.messageView.hidden = YES;
    }
    [self bringSubviewToFront:self.messageView];
    [self.messageView showImage:imageName];
}

@end

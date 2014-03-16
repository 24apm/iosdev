//
//  NumberGameView.m
//  NumberGame
//
//  Created by MacCoder on 2/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GamePlayView.h"
#import "GameManager.h"
#import "MonsterView.h"
#import "GameConstants.h"
#import "SoundManager.h"
#import "UserData.h"
#import "AnimUtil.h"
#import "InGameMessageView.h"

@interface GamePlayView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) CFTimeInterval startingTime;
@property (nonatomic) double finalTime;
@property (nonatomic, strong) InGameMessageView *messageView;

@end

@implementation GamePlayView

- (void)show {
    self.startingTime = 0;
    self.timeLabel.text = [NSString stringWithFormat:@"0.00"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGameCallback) name:GAME_MANAGER_REFRESH_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lostGame) name:GAME_MANAGER_END_GAME_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(victoryGame) name:GAMEPLAY_VIEW_VICTORY_NOTIFICATION object:nil];
    [self renewGame];
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
        [self wobbleUnits];
    }];
}

- (void)wobbleUnits {
    for (int i = 0; i < self.imagePlaceHolder.count; i++) {
        [AnimUtil wobble:[self.imagePlaceHolder objectAtIndex:i] duration:1.f angle:M_PI/128.f repeatCount:HUGE_VAL];
    }
}

- (void)removeWobbleUnits {
    for (int i = 0; i < self.imagePlaceHolder.count; i++) {
        UIView *unit = [self.imagePlaceHolder objectAtIndex:i];
        [unit.layer removeAllAnimations];
    }
}

- (void)hide {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
        self.alpha = 0.0f;
    } completion:^(BOOL complete) {
        [self removeWobbleUnits];
    }];
}

- (void)renewGame{
    [[GameManager instance] generatelevel];
    [self refreshGame];
}

- (void)refreshGameCallback {
    NSArray *xPositions = @[@(self.width), @(-self.width)];
    float x = [[xPositions randomObject] floatValue];
    float y = [Utils randBetweenMinInt:0 max:self.height];
    
    [self animate:[self.imagePlaceHolder objectAtIndex:0] toPoint:CGPointMake(x,y)];
    [self refreshGame];
}

- (void)refreshGame {
    NSArray *visibleUnits = [[GameManager instance] currentVisibleQueue];
    for (int i = 0; i < self.imagePlaceHolder.count; i++) {
        int unitType;
        if (i < visibleUnits.count) {
            unitType = ((MonsterData *)[visibleUnits objectAtIndex:i]).unitType;
        } else {
            unitType = UnitTypeEmpty;
        }
        MonsterView *monsterView = [self.imagePlaceHolder objectAtIndex:i];
        [monsterView refreshImage:[[GameManager instance] imagePathFor:unitType]];
    }
}

- (IBAction)leftButtonPressed:(UIButton *)sender {
    // tell manager to dosomething with action
    if (self.timer == nil) {
        [self startTime];
    }
    [[SoundManager instance]play:SOUND_EFFECT_POP];
    [self animateWeapon:UserInputDefend];
    [[GameManager instance] sequenceCaculation:UserInputDefend];
}


- (IBAction)rightButtonPressed:(UIButton *)sender {
    if (self.timer == nil) {
        [self startTime];
    }
    [[SoundManager instance]play:SOUND_EFFECT_POP];
    [self animateWeapon:UserInputAttack];
    [[GameManager instance] sequenceCaculation:UserInputAttack];
}

- (void)startTime {
    self.startingTime = CACurrentMediaTime();
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)updateTimer {
    double currentTime = CACurrentMediaTime() - self.startingTime;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%.2F", currentTime];
}

- (void)endGame {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [[NSNotificationCenter defaultCenter] postNotificationName:GAMEPLAY_VIEW_DISMISSED_NOTIFICATION object:self];
    [self hide];
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

- (void)animate:(UIView *)fromView toPoint:(CGPoint)toPoint {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[fromView blit]];
    [self addSubview:imageView];
    imageView.frame = [fromView.superview convertRect:fromView.frame toView:self];

    CABasicAnimation *bubbleFadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    bubbleFadeIn.fromValue = [NSNumber numberWithFloat:1.0f];
    bubbleFadeIn.toValue = [NSNumber numberWithFloat:0.0f];
    
    float scaleRand = [Utils randBetweenMinInt:0 max:4];
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

- (void)lostGame {
    [self.timer invalidate]; self.timer = nil;
//    [[SoundManager instance] play:SOUND_EFFECT_BOING];
//    [self animateMonsterScaledIn:[self.imagePlaceHolder objectAtIndex:0]];
    [self performSelector:@selector(shakeScreen) withObject:nil afterDelay:0.5f];
    [self showMessageView:@"T_______T"];
    [self performSelector:@selector(endGame) withObject:nil afterDelay:2.0f];
}

- (void)shakeScreen {
    [AnimUtil wobble:self duration:0.1f angle:M_PI/128.f repeatCount:2];
}

- (void)victoryGame {
    [self.timer invalidate]; self.timer = nil;
    self.finalTime = CACurrentMediaTime() - self.startingTime;
    [[UserData instance] addNewScoreLocalLeaderBoard:self.finalTime];
    [self showMessageView:@"VICTORY!"];
    [[SoundManager instance] play:SOUND_EFFECT_WINNING];
    [self performSelector:@selector(endGame) withObject:nil afterDelay:2.0f];
}

@end

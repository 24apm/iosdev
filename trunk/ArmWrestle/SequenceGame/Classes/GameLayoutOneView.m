//
//  GameLayoutView.m
//  SequenceGame
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimUtil.h"
#import "GameLayoutOneView.h"
#import "GameManager.h"
#import "SoundManager.h"
#import "GameConstants.h"
#import "InGameMessageView.h"

@interface GameLayoutOneView()

@property (nonatomic, strong) InGameMessageView *messageView;
@property (nonatomic) CGPoint maleDefault;
@property (nonatomic) CGPoint femaleDefault;
@property (nonatomic, strong) NSString *timeTextDefault;
@property (nonatomic) int gender;

@end

@implementation GameLayoutOneView

- (void)randomGender {
    NSArray *people = [NSArray arrayWithObjects:[NSNumber numberWithInt:GenderMale], [NSNumber numberWithInt:GenderFemale], nil];
    self.gender = [[people randomObject] intValue];
}

- (void)setupDefault {
    self.maleDefault = self.male.center;
    self.femaleDefault = self.female.center;
    
    [self restoreDefault];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Here your non-main thread.
        [self initAnimateCloud];
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
}

- (void)restoreDefault {
    [self randomGender];
    self.male.center = self.maleDefault;
    self.female.center = self.femaleDefault;
    self.doorAfter.hidden = YES;
    self.handView1.alpha = 0.0f;
    self.introView.hidden = YES;
    self.introMale.hidden = YES;
    self.introFemale.hidden = YES;
    self.introOpenDoor.hidden = YES;
    self.introCloseDoor.hidden = YES;
    self.introPerson.hidden = YES;
    self.doorClose.hidden = NO;
    self.male.hidden = YES;
    self.female.hidden = YES;
    self.person.hidden = NO;
    self.door.hidden = YES;
    self.rightButton.hidden = NO;
    self.leftButton.hidden = NO;
    self.timeLabel.hidden = YES;
    self.cloud.hidden = YES;
    self.badBubble.hidden = YES;
}

- (void)handShow {
    [self fadeInAndOut:self.handView1];
}

- (void)handHide {
    [self removeFadeInAndOut:self.handView1];
}

- (void)fadeInAndOut:(UIView *)view {
    CABasicAnimation *fadeInAndOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAndOut.fromValue = [NSNumber numberWithFloat:0.0f];
    fadeInAndOut.toValue = [NSNumber numberWithFloat:1.f];
    fadeInAndOut.autoreverses = YES;
    fadeInAndOut.duration = 0.8f;
    fadeInAndOut.repeatCount = HUGE_VAL;
    [view.layer addAnimation:fadeInAndOut forKey:@"fadeInAndOut"];
}

- (void)removeFadeInAndOut:(UIView *)view {
    [view.layer removeAnimationForKey:@"fadeInAndOut"];
}

- (void)animateCharacter:(UIView *)view startPoint:(CGPoint)startPoint midPoint:(CGPoint)midPoint endPoint:(CGPoint)endPoint {
    NSArray *positionValues = [NSArray arrayWithObjects:
                               [NSNumber valueWithCGPoint:startPoint],
                               [NSNumber valueWithCGPoint:midPoint],
                               [NSNumber valueWithCGPoint:endPoint],
                               nil];
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    position.values = positionValues;
    position.keyTimes = @[@(0.0f),@(0.2f),@(0.9f)];
    
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    [groupAnimation setAnimations:[NSArray arrayWithObjects:position, nil]];
    [groupAnimation setDuration:.5f];
    [groupAnimation setRemovedOnCompletion:NO];
    [groupAnimation setFillMode:kCAFillModeForwards];
    [view.layer addAnimation:groupAnimation forKey:@"animateIn"];
}

- (void)enterGirl {
    self.introPerson.hidden = YES;
    self.introCloseDoor.hidden = YES;
    self.introFemale.hidden = NO;
    [AnimUtil wobble:self.introFemale duration:0.3f angle:M_PI/128.f repeatCount:HUGE_VAL];
    self.introBackground.image = [UIImage imageNamed:@"pinkbackground"];
    self.female.hidden = NO;
    self.rightButton.hidden = YES;
    [self animateCharacter:self.introFemale
                startPoint:CGPointMake(0.0f,self.introFemale.center.y)
                  midPoint:CGPointMake(self.width/4, self.introFemale.center.y)
                  endPoint:CGPointMake(self.width/2, self.introFemale.center.y)];
}

- (void)enterBoy {
    self.introPerson.hidden = YES;
    self.introCloseDoor.hidden = YES;
    self.introFemale.hidden = YES;
    self.introMale.hidden = NO;
    [AnimUtil wobble:self.introMale duration:0.3f angle:M_PI/128.f repeatCount:HUGE_VAL];
    self.introBackground.image = [UIImage imageNamed:@"bluebackground"];
    self.male.hidden = NO;
    self.leftButton.hidden = YES;
    [self animateCharacter:self.introMale
                startPoint:CGPointMake(self.width,self.introMale.center.y)
                  midPoint:CGPointMake(self.width - self.width/4, self.introMale.center.y)
                  endPoint:CGPointMake(self.width/2, self.introMale.center.y)];
}

- (void)enterPerson {
    self.introBackground.image = [UIImage imageNamed:@"defaultbackground"];
    self.introPerson.hidden = NO;
    self.introOpenDoor.hidden = NO;
    [self animateCharacter:self.introPerson
                startPoint:CGPointMake(self.introPerson.center.x, self.height)
                  midPoint:CGPointMake(self.introPerson.center.x, self.introCloseDoor.height)
                  endPoint:CGPointMake(self.introPerson.center.x, self.introCloseDoor.center.y)];
}
- (void)closeDoor {
    //[[SoundManager instance] play:SOUND_EFFECT_DOOR_CLOSE];
    self.introPerson.hidden = NO;
    self.introOpenDoor.hidden = YES;
    self.introCloseDoor.hidden = NO;
}

- (void)introEnd {
    self.introMale.hidden = YES;
    self.introView.hidden = YES;
    [self.introMale.layer removeAnimationForKey:@"iconShake"];
    [self.introFemale.layer removeAnimationForKey:@"iconShake"];
    [AnimUtil wobble:self.male duration:0.3f angle:M_PI/128.f repeatCount:HUGE_VAL];
    [AnimUtil wobble:self.female duration:0.3f angle:M_PI/128.f repeatCount:HUGE_VAL];
    self.cloud.hidden = NO;
    [self.cloud startAnimating];
}

- (void)introduction {
    self.introView.hidden = NO;
    float delay = 0.0f;
    [self performSelector:@selector(enterPerson) withObject:Nil afterDelay:delay];
    
    delay += 1.5f;
    [self performSelector:@selector(closeDoor) withObject:Nil afterDelay:delay];
    
    
    if (self.gender == GenderFemale) {
        delay += 1.0f;
        [self performSelector:@selector(enterGirl) withObject:Nil afterDelay:delay];
    } else {
        delay += 1.5f;
        [self performSelector:@selector(enterBoy) withObject:Nil afterDelay:delay];
    }
    
    delay += 1.8f;
    [self performSelector:@selector(introEnd) withObject:Nil afterDelay:delay];
}

- (IBAction)leftButtonPressed:(UIButton *)sender {
    [self performSelector:@selector(leftPressed) withObject:nil afterDelay:0.05f];
    [[SoundManager instance]play:SOUND_EFFECT_POP];
    //    MonsterView *monsterView = [self.imagePlaceHolder objectAtIndex:0];
    // [self animatePopFrontUnitFrom:monsterView toView: self.leftButton];
    self.currentButton = self.leftButton;
}

- (void)leftPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GAME_LAYOUT_VIEW_LEFT_BUTTON_PRESSED object:nil];
}

- (IBAction)rightButtonPressed:(UIButton *)sender {
    [self performSelector:@selector(rightPressed) withObject:nil afterDelay:0.05f];
    
    [[SoundManager instance] play:SOUND_EFFECT_POP];
    // MonsterView *monsterView = [self.imagePlaceHolder objectAtIndex:0];
    
    //    [self animatePopFrontUnitFrom:monsterView toView: self.rightButton];
    self.currentButton = self.rightButton;
    
}

- (void)rightPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GAME_LAYOUT_VIEW_RIGHT_BUTTON_PRESSED object:nil];
}

#pragma mark - Animation

- (void)roundStart {
    [self handShow];
    self.doorClose.hidden = YES;
    self.door.hidden = NO;
    self.timeLabel.hidden = NO;
    self.cloud.hidden = YES;
    [self.cloud stopAnimating];
}
- (void)animateMovingToDoorFor:(UIView *)view {
    [self.male.layer removeAnimationForKey:@"iconShake"];
    [self.female.layer removeAnimationForKey:@"iconShake"];
    [self animateUnitFrom:view toView:self.person];
}

- (void)animateMovingAwayfromDoorFor:(UIImageView *)view {
    self.doorAfter.hidden = NO;
    self.door.hidden = YES;
    CGPoint randPoint;
    randPoint.x = [Utils randBetweenMin:0.f max:self.width];
    randPoint.y = self.height;
    [self animate:view toPoint:randPoint];
}

- (void)animate:(UIImageView *)view toPoint:(CGPoint)toPoint {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:view.image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    imageView.frame = [view.superview convertRect:view.frame toView:self];
    CABasicAnimation *bubbleFadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    bubbleFadeIn.fromValue = [NSNumber numberWithFloat:1.0f];
    bubbleFadeIn.toValue = [NSNumber numberWithFloat:0.8f];
    
    // float scaleRand = [Utils randBetweenMinInt:0 max:4];
    CABasicAnimation *bubbleExplode = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bubbleExplode.toValue = [NSNumber numberWithFloat:10];
    
    CABasicAnimation *bubblePosition = [CABasicAnimation animationWithKeyPath:@"position"];
    bubblePosition.toValue = [NSNumber valueWithCGPoint:toPoint];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0f];
    rotationAnimation.duration = 0.4f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;
    
    CAAnimationGroup *bubbleAnims = [CAAnimationGroup animation];
    [bubbleAnims setAnimations:[NSArray arrayWithObjects:bubbleFadeIn, bubblePosition, rotationAnimation, nil]];
    [bubbleAnims setDuration:.5f];
    [bubbleAnims setRemovedOnCompletion:NO];
    [bubbleAnims setFillMode:kCAFillModeForwards];
    [imageView.layer addAnimation:bubbleAnims forKey:nil];
    
    [self performSelector:@selector(removeView:) withObject:imageView afterDelay:bubbleAnims.duration + 0.1f];
}

- (void)removeView:(UIView *)view {
    [view removeFromSuperview];
}

- (void)animateUnitFrom:(UIView *)fromView toView:(UIView *)toView {
    // NSArray *xPositions = @[@(self.width), @(0)];
    
    //    CGPoint screenPointForFromView = [fromView.superview convertPoint:fromView.center toView:self];
    //
    //    CGPoint screenPointForButton = [toView.superview convertPoint:toView.center toView:self];
    //
    //
    
    [UIView animateWithDuration:0.4f animations: ^{
        fromView.center = toView.center;
    }];
    
    //    [self animateOut:imagePath fromPoint:screenPointForFromView toPoint:screenPointForButton];
}

- (void)animatePopFrontUnitFrom:(UIView *)fromView toView:(UIView *)toView {
    // NSArray *xPositions = @[@(self.width), @(0)];
    //  MonsterView *monsterView = [self.imagePlaceHolder objectAtIndex:0];
    
    //   CGPoint screenPointForFromView = [fromView.superview convertPoint:fromView.center toView:self];
    
    // CGPoint screenPointForButton = [toView.superview convertPoint:toView.center toView:self];
    
    //  [self animate:monsterView fromPoint:screenPointForFromView toPoint:screenPointForButton];
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

- (void)animateLostView {
    //  [self animateOutPopFrontUnit:[self imageForCurrentDefeatedUnitType] fromView:self.currentButton toView:self];
    [self performSelector:@selector(animateMessageView) withObject:nil afterDelay:0.3f];
}

- (void)animateMessageView {
    [self shakeScreen];
    [self showMessageView:@"TOO FAST!"];
    //[[SoundManager instance] play:SOUND_EFFECT_SHARP_PUNCH];
}

- (void)flash {
    UIView *flashOverView = [[UIView alloc] init];
    [self addSubview:flashOverView];
    flashOverView.frame = self.frame;
    flashOverView.backgroundColor = [UIColor whiteColor];
    
    float duration = 0.2f;
    flashOverView.alpha = 0.0f;
    [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionLayoutSubviews animations:^{
        flashOverView.alpha = 1.0f;
    } completion:^(BOOL completed){
        [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionLayoutSubviews animations:^{
        } completion:^(BOOL completed){
            flashOverView.alpha = 0.0f;
            [flashOverView removeFromSuperview];
        } ];
    } ];
    
    [self handHide];
}

- (void)initAnimateCloud {
    UIImage* img1 = [UIImage imageNamed:@"cloud1"];
    UIImage* img2 = [UIImage imageNamed:@"cloud2"];
    NSArray *images = [NSArray arrayWithObjects:img1,img2, nil];
    self.cloud.animationImages = images;
    self.cloud.animationRepeatCount = HUGE_VAL;
    self.cloud.animationDuration = 1.0f;
}

@end

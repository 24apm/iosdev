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
@property (nonatomic) CGPoint maleDefault;
@property (nonatomic) CGPoint femaleDefault;
@property (nonatomic, strong) NSString* timeTextDefault;

@end

@implementation GameLayoutView

- (void)setupDefault {
    self.maleDefault = self.male.center;
    self.femaleDefault = self.female.center;
    [self initAnimateCloud];
    [self restoreDefault];
}

- (void)restoreDefault {
    self.male.center = self.maleDefault;
    self.female.center = self.femaleDefault;
    self.timeText.text = self.timeTextDefault;
    self.doorAfter.hidden = YES;
    self.handView1.alpha = 0.0f;
    self.handView2.alpha = 0.0f;
    self.introView.hidden = YES;
    self.introMale.hidden = YES;
    self.introFemale.hidden = YES;
    self.introOpenDoor.hidden = YES;
    self.introCloseDoor.hidden = YES;
    self.introPerson.hidden = YES;
    self.timeText.hidden = YES;
    self.doorClose.hidden = NO;
    self.male.hidden = NO;
    self.female.hidden = NO;
    self.person.hidden = NO;
    self.door.hidden = YES;
    self.timeLabel.hidden = NO;
    self.rightButton.hidden = NO;
    self.leftButton.hidden = NO;
    self.timeLabel.hidden = YES;
    self.cloud.hidden = YES;
    self.delay = 0;
    self.badBubble.hidden = YES;
}

- (void)gameplayEnd {
    self.rightButton.hidden = YES;
    self.leftButton.hidden = YES;
}
- (void)handShow {
    [self fadeInAndOut:self.handView1];
    [self fadeInAndOut:self.handView2];
}

- (void)handHide {
    [self removeFadeInAndOut:self.handView1];
    [self removeFadeInAndOut:self.handView2];
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
    self.timeText.text = @"GIRL";
    self.introFemale.hidden = NO;
    [AnimUtil wobble:self.introFemale duration:0.3f angle:M_PI/128.f repeatCount:HUGE_VAL];
    self.introBackground.image = [UIImage imageNamed:@"pinkbackground"];
    [self animateCharacter:self.introFemale
                startPoint:CGPointMake(0.0f,self.introFemale.center.y)
                  midPoint:CGPointMake(self.width/4, self.introFemale.center.y)
                  endPoint:CGPointMake(self.width/2, self.introFemale.center.y)];
}

- (void)enterBoy {
    self.introFemale.hidden = YES;
    self.introMale.hidden = NO;
    self.timeText.text = @"BOY";
    [AnimUtil wobble:self.introMale duration:0.3f angle:M_PI/128.f repeatCount:HUGE_VAL];
    self.introBackground.image = [UIImage imageNamed:@"bluebackground"];
    [self animateCharacter:self.introMale
                startPoint:CGPointMake(self.width,self.introMale.center.y)
                  midPoint:CGPointMake(self.width - self.width/4, self.introMale.center.y)
                  endPoint:CGPointMake(self.width/2, self.introMale.center.y)];
}

- (void)enterPerson {
    self.timeText.text = @"ONE BATHROOM!";
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
    self.timeText.text = @"WHO IS NEXT?";
    self.introPerson.hidden = NO;
    self.introOpenDoor.hidden = YES;
    self.introCloseDoor.hidden = NO;
}

- (void)introEnd {
    self.introFemale.hidden = YES;
    self.introMale.hidden = YES;
    self.introView.hidden = YES;
    self.timeText.hidden = YES;
    [self.introMale.layer removeAnimationForKey:@"iconShake"];
    [self.introFemale.layer removeAnimationForKey:@"iconShake"];
    [AnimUtil wobble:self.female duration:0.3f angle:M_PI/128.f repeatCount:HUGE_VAL];
    [AnimUtil wobble:self.male duration:0.3f angle:M_PI/128.f repeatCount:HUGE_VAL];
    [self.cloud startAnimating];
    self.cloud.hidden = NO;
}

- (void)introduction {
    self.introView.hidden = NO;
    // self.userInteractionEnabled = NO;
    self.timeText.hidden = YES;
    float delay = 0.0f;
    [self performSelector:@selector(enterPerson) withObject:Nil afterDelay:delay];
    
    //    delay += 1.5f;
    //    [self performSelector:@selector(intro2) withObject:Nil afterDelay:delay];
    
    delay += 1.5f;
    [self performSelector:@selector(closeDoor) withObject:Nil afterDelay:delay];
    
    //    delay += 2.0;
    //    [self performSelector:@selector(intro4) withObject:Nil afterDelay:delay];
    
    delay += 1.0f;
    [self performSelector:@selector(enterGirl) withObject:Nil afterDelay:delay];
    
    delay += 1.5f;
    [self performSelector:@selector(enterBoy) withObject:Nil afterDelay:delay];
    
    delay += 1.8f;
    [self performSelector:@selector(introEnd) withObject:Nil afterDelay:delay];
}

- (IBAction)leftButtonPressed:(UIButton *)sender {
    [self performSelector:@selector(leftPressed) withObject:nil afterDelay:0.05f];
    [[SoundManager instance]play:SOUND_EFFECT_POP];
    [self animateWeapon:UserInputDefend];
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
    [self animateWeapon:UserInputAttack];
    // MonsterView *monsterView = [self.imagePlaceHolder objectAtIndex:0];
    
    //    [self animatePopFrontUnitFrom:monsterView toView: self.rightButton];
    self.currentButton = self.rightButton;
    
}

- (void)rightPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GAME_LAYOUT_VIEW_RIGHT_BUTTON_PRESSED object:nil];
}

- (void)updateUnitViews:(NSArray *)visibleUnits {
    for (int i = 0; i < self.imagePlaceHolder.count; i++) {
        MonsterData *data;
        if (i < visibleUnits.count) {
            data = ((MonsterData *)[visibleUnits objectAtIndex:i]);
        } else {
            data = nil;
        }
        MonsterView *monsterView = [self.imagePlaceHolder objectAtIndex:i];
        [monsterView setupWithMonsterData:data];
    }
}

#pragma mark - Animation

- (void)roundStart {
    [self handShow];
    self.doorClose.hidden = YES;
    self.door.hidden = NO;
    self.timeLabel.hidden = NO;
    [self.cloud stopAnimating];
    self.cloud.hidden = YES;
    //self.badBubble.hidden = NO;
   // [self animateBadBubble];
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

- (void)animateOut:(NSString *)imagePath fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    
    
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

- (void)wobbleUnits {
    //  for (int i = 0; i < self.imagePlaceHolder.count; i++) {
    float durationRand = [Utils randBetweenMin:0.2f max:0.5f];
    [AnimUtil wobble:[self.imagePlaceHolder objectAtIndex:0] duration:durationRand angle:M_PI/128.f repeatCount:HUGE_VAL];
    //}
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

- (NSString *)imageForCurrentDefeatedUnitType {
    MonsterView *monster = [self.imagePlaceHolder objectAtIndex:0];
    MonsterData *monsterData = monster.data;
    UnitType unitType = monsterData.unitType;
    NSString *defeatedImage = [MonsterData imageForDefeated:unitType];
    return defeatedImage;
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

- (MonsterView *)frontImagePlaceHolder {
    return [self.imagePlaceHolder objectAtIndex:0];
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

-(void)animateBadBubble {
    CABasicAnimation *bubbleExplode = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bubbleExplode.toValue = [NSNumber numberWithFloat:10.f];
    
    CABasicAnimation *bubbleFadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    bubbleFadeIn.fromValue = [NSNumber numberWithFloat:1.0f];
    bubbleFadeIn.toValue = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *bubbleAnims = [CAAnimationGroup animation];
    [bubbleAnims setAnimations:[NSArray arrayWithObjects:bubbleFadeIn, bubbleExplode, nil]];
    [bubbleAnims setDuration:.5f];
    [bubbleAnims setRemovedOnCompletion:NO];
    [bubbleAnims setFillMode:kCAFillModeForwards];
    [self.badBubble.layer addAnimation:bubbleAnims forKey:nil];
    [self performSelector:@selector(removeBadBubble) withObject:self.badBubble afterDelay:bubbleAnims.duration + 0.1f];
}

- (void)removeBadBubble {
    [self.badBubble removeFromSuperview];
    self.badBubble.hidden = YES;
}
- (void)initAnimateCloud {
    UIImage* img1 = [UIImage imageNamed:@"cloud1"];
    UIImage* img2 = [UIImage imageNamed:@"cloud2"];
    NSArray *images = [NSArray arrayWithObjects:img1,img2, nil];
    self.cloud.animationImages = images;
    self.cloud.animationRepeatCount = HUGE_VAL;
    self.cloud.animationDuration = 1.0f;
}

- (IBAction)introPressed:(UIButton *)sender {
    [self introEnd];
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GAME_INTRO_SKIPPED object:self];
}

@end

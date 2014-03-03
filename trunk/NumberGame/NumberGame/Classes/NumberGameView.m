//
//  NumberGameView.m
//  NumberGame
//
//  Created by MacCoder on 2/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "NumberGameView.h"
#import "NumberManager.h"
#import "Utils.h"
#import "InGameMessageView.h"
#import "GameConstants.h"
#import "UserData.h"
#import "SoundEffect.h"
#import "SoundManager.h"
#import <StoreKit/StoreKit.h>
#import "NumberGameIAPHelper.h"

#define BUFFER_TIME 0.f
#define SOUND_EFFECT_DING @"ding"
#define SOUND_EFFECT_POP @"pop"
#define SOUND_EFFECT_BLING @"bling"
#define SOUND_EFFECT_BOING @"boing"
#define SOUND_EFFECT_TICKING @"ticking"
#define SOUND_EFFECT_WINNING @"winningEffect"

@interface NumberGameView ()

//@property (nonatomic) int answerSlotsNum;

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic) double nextExpireTime;
@property (nonatomic) double maxTime;
@property (nonatomic, retain) UIColor *numberBackgroundColor;
@property (nonatomic, retain) UIColor *operatorBackgroundColor;
@property (nonatomic, retain) InGameMessageView *messageView;
@property (nonatomic) int currentScore;
@property (nonatomic) int topScore;
@property (nonatomic) BOOL playedTick;
@property (strong, nonatomic) IBOutlet UILabel *topScoreLabel;


@end

@implementation NumberGameView

- (void)setup {
    [super setup];
    for (int i = 0; i < self.choiceSlots.count; i++) {
        UIButton *choice = [self.choiceSlots objectAtIndex:i];
        choice.tag = i+1;
        self.currentScore = 0;
        [self preloadSounds];
    }
    self.playedTick = NO;
    self.maxTime = 10.f;
    [self loadUserData];
    self.numberBackgroundColor = [UIColor colorWithRed:84.f/255.f green:255.f/255.f blue:136.f/255.f alpha:1.0f];
    self.operatorBackgroundColor = [UIColor colorWithRed:67.f/255.f green:204.f/255.f blue:109.f/255.f alpha:1.0f];
}


- (void)loadUserData {
    [UserData instance].maxScore = [[[NSUserDefaults standardUserDefaults] valueForKey:@"maxScore"] intValue];
    self.topScoreLabel.text = [self updateMaxScore];
}


- (void)preloadSounds {
    [[SoundManager instance] prepare:SOUND_EFFECT_TICKING count:1];
    [[SoundManager instance] prepare:SOUND_EFFECT_WINNING count:2];
    [[SoundManager instance] prepare:SOUND_EFFECT_BOING count:5];
    [[SoundManager instance] prepare:SOUND_EFFECT_POP count:5];
    [[SoundManager instance] prepare:SOUND_EFFECT_BLING count:5];
    [[SoundManager instance] prepare:SOUND_EFFECT_DING count:5];
}

-(void)setCurrentScore:(int)currentScore {
    _currentScore = currentScore;
    self.scoreLabel.text = [NSString stringWithFormat: @"Streak: %d",_currentScore];
}

- (void)showMessageView {
    if (!self.messageView) {
        self.messageView = [[InGameMessageView alloc] init];
        [self addSubview:self.messageView];
        self.messageView.frame = self.frame;
        self.messageView.hidden = YES;
    }
    [self bringSubviewToFront:self.messageView];
    [self.messageView show];
}

- (IBAction)cheatPressed:(id)sender {
    [self showAnswer];
    [self.progressBar fillBar:0.f animated:NO];
    [self.timer invalidate];
    [[SoundManager instance] play:SOUND_EFFECT_WINNING];
    [UserData instance].score = self.currentScore;
    [UserData instance].lastGameSS = [self blit];
    [[NSNotificationCenter defaultCenter] postNotificationName:NUMBER_GAME_CALLBACK_NOTIFICATION object:self];
}

-(void)showAnswer {
    self.cheatLabel.hidden = NO;
    NSString *t = @"Answer: ";
    NSMutableArray *newArray = [[NumberManager instance] currentGeneratedAnswerInStrings];
    for (int i = 0; i < newArray.count; i++) {
        t = [NSString stringWithFormat:@"%@ %@",t, [newArray objectAtIndex:i]];
    }
    self.cheatLabel.text = t;
}

- (void)updateProgressBar {
    float percentage = (self.nextExpireTime - CACurrentMediaTime()) / self.maxTime;
    
    if (percentage > 0) {
        [self.progressBar fillBar:percentage animated:NO];
        
        // time is running out
        if (!self.playedTick && self.nextExpireTime - CACurrentMediaTime() < 4.4) {
            [[SoundManager instance] play:SOUND_EFFECT_TICKING];
            self.progressBar.foregroundView.backgroundColor = [UIColor redColor];
            
            self.playedTick = YES;
        }
    } else {
        [self showAnswer];
        [self.progressBar fillBar:0.f animated:NO];
        [self.timer invalidate];
        [[SoundManager instance] stop:SOUND_EFFECT_TICKING];
        [[SoundManager instance] play:SOUND_EFFECT_WINNING];
        [UserData instance].score = self.currentScore;
        [UserData instance].lastGameSS = [self blit];
        if (self.currentScore > self.topScore) {
            self.topScore = self.currentScore;
            [self.topScoreLabel setText:[self updateMaxScore]];
        }
        [self hide];
    }
}

- (void)refreshGame {
    // self.answerSlotsNum = 0;
    //int maxNumberRange = 10;
    NSDictionary *data = [[NumberManager instance] generateLevel:self.answerSlots.count choiceSlots:self.choiceSlots.count];
    int targetValue = [[data objectForKey:@"targetNumber"] intValue];
    NSArray *array = [data objectForKey:@"algebra"];
    [self refreshChoices:array];
    [self resetAnswers];
    self.progressBar.foregroundView.backgroundColor = [UIColor colorWithRed:71.f/255.f
                                                                      green:216.f/255.f
                                                                       blue:115.f/255.f
                                                                      alpha:1.f];
    self.targetNumberLabel.text = [NSString stringWithFormat:@"%d",targetValue];
    self.playedTick = NO;
    
    self.nextExpireTime = CACurrentMediaTime() + self.maxTime + BUFFER_TIME;
    self.cheatLabel.hidden = YES;
    
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.f target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
}

- (void)animateAnswersOut {
    for (int i = 0; i < self.answerSlots.count; i++) {
        UIButton *button = [self.answerSlots objectAtIndex:i];
        if (button.tag > 0) {
            [self animateBlitAndFadeout:button delay:i * 0.3f + 1.5f];
        }
    }
}

- (void)animateBlitAndFadeout:(UIView *)view delay:(float)delay {
    UIImageView *blitView = [[UIImageView alloc] initWithImage:[view blit]];
    [self addSubview:blitView];
    blitView.frame = [view.superview convertRect:view.frame toView:blitView.superview];
    
    [UIView animateWithDuration:0.3f
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         blitView.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
                         blitView.alpha = 0.2f;
                     } completion:^(BOOL complete) {
                         [[SoundManager instance]play:SOUND_EFFECT_POP];
                         [blitView removeFromSuperview];
                     }];
}

- (void)refreshChoices:(NSArray *)array {
    for(int i = 0; i < self.choiceSlots.count; i++) {
        UIButton *slot = [self.choiceSlots objectAtIndex:i];
        NSString *arrayTitle;
        if ([array[i] isKindOfClass: [NSNumber class]]) {
            arrayTitle = [NSString stringWithFormat:@"%d", [((NSNumber *)array[i])intValue]];
            slot.backgroundColor = self.numberBackgroundColor;
        } else{
            slot.backgroundColor = self.operatorBackgroundColor;
            arrayTitle = array[i];
        }
        [slot setTitle:arrayTitle forState:UIControlStateNormal];
    }
    [self resetChoices];
}

- (void)resetChoices {
    for(int i = 0; i < self.choiceSlots.count; i++) {
        UIButton *slot = [self.choiceSlots objectAtIndex:i];
        slot.selected = NO;
        slot.layer.cornerRadius = slot.height * 0.1f;
    }
}

- (void)resetAnswers {
    for (int i = 0; i < self.answerSlots.count; i++) {
        UIButton *slot = [self.answerSlots objectAtIndex:i];
        slot.tag = 0;
        [slot setTitle:@"" forState:UIControlStateNormal];
        if (i % 2 == 0) {
            slot.layer.borderColor = self.numberBackgroundColor.CGColor;
        } else {
            slot.layer.borderColor = self.operatorBackgroundColor.CGColor;
        }
        slot.layer.borderWidth = 2.f * IPAD_SCALE;
        slot.layer.cornerRadius = slot.height * 0.1f;
        slot.backgroundColor = [UIColor clearColor];
    }
}

- (void)show {
    self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    self.alpha = 0;
    self.currentScore = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [UIView animateWithDuration:0.3f animations:^ {
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }];
    [self refreshGame];
}

- (void)hide {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.3f, 0.3f);
        self.alpha = 0.0f;
    } completion:^(BOOL complete) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NUMBER_GAME_CALLBACK_NOTIFICATION object:self];
    }];
}


- (void)productPurchased:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    if (productIdentifier) {
        // Unlock answer
        [self showAnswer];
    }
}

- (IBAction)answerSlotPressed:(UIButton *)sender {
    [self removeSlot:sender];
    [[SoundManager instance] play:SOUND_EFFECT_POP];
}

- (IBAction)choiceSlotPressed:(UIButton *)sender {
    BOOL hasFound = NO;
    for (int i = 0; i < self.answerSlots.count; i++){
        UIButton *answer = [self.answerSlots objectAtIndex:i];
        if (sender.tag == answer.tag) {
            [self removeSlot:answer];
            [[SoundManager instance] play:SOUND_EFFECT_POP];
            hasFound = YES;
            break;
        }
    }
    
    if (!hasFound) {
        [self fillSlot:sender];
    }
}

- (void)animate:(UIView *)fromView toView:(UIView *)toView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[fromView blit]];
    [fromView.superview addSubview:imageView];
    imageView.frame = fromView.frame;
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         imageView.frame = [toView.superview convertRect:toView.frame toView:fromView.superview];
                     } completion:^(BOOL completed) {
                         [UIView animateWithDuration:0.3f
                                               delay:0.f
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              imageView.alpha = 0.3f;
                                          } completion:^(BOOL completed) {
                                              [imageView removeFromSuperview];
                                          }];
                     }];
}

- (void)fillSlot:(UIButton *)choice {
    // find first empty slot
    NSMutableArray *algebra = [NSMutableArray array];
    NSString *choiceString = [choice titleForState:UIControlStateNormal];
    BOOL isOperator = [[NumberManager instance] isOperator:choiceString];
    for(int i = 0; i < self.answerSlots.count; i++) {
        UIButton *slot = self.answerSlots[i];
        // fill the slot with choice button if there is one
        if (slot.tag == 0) {
            if (isOperator && i % 2 == 0) {
                [self animateIncorrectAnswer];
                [[SoundManager instance]play:SOUND_EFFECT_BOING];
                break;
            }
            
            if (!isOperator && i % 2 == 1) {
                [self animateIncorrectAnswer];
                [[SoundManager instance]play:SOUND_EFFECT_BOING];
                break;
            }
            [slot setTitle:choiceString forState:UIControlStateNormal];
            //  disable current choice
            
            choice.selected = YES;
            //  set slot with choice's tag (keep reference)
            slot.tag = choice.tag;
            
            [self animate:choice toView:slot];
            [[SoundManager instance] play:SOUND_EFFECT_POP];
            break;
        }
    }
    
    BOOL hasEmpty = NO;
    for(int i = 0; i < self.answerSlots.count; i++) {
        UIButton *slot = self.answerSlots[i];
        if (slot.tag == 0) {
            hasEmpty = YES;
        } else {
            [algebra addObject:[slot titleForState:UIControlStateNormal]];
        }
    }
    if (hasEmpty == NO){
        float targetValue = [self.targetNumberLabel.text floatValue];
        BOOL isCorrect =[[NumberManager instance] checkAlgebra:algebra targetValue:targetValue];
        if (isCorrect) {
            [self.timer invalidate];
            [[SoundManager instance] stop:SOUND_EFFECT_TICKING];
            [self animateAnswersOut];
            [self showMessageView];
            [[SoundManager instance]play:SOUND_EFFECT_BLING];
            [self resetAnswers];
            [self.progressBar fillBar:1.0f animated:YES];
            self.progressBar.foregroundView.backgroundColor = [UIColor colorWithRed:71.f/255.f
                                                                              green:216.f/255.f
                                                                               blue:115.f/255.f
                                                                              alpha:1.f];
            [self performSelector:@selector(refreshGame) withObject:nil afterDelay:2.2f];
            self.currentScore++;
        } else {
            [self animateIncorrectAnswer];
            [[SoundManager instance]play:SOUND_EFFECT_BOING];
        }
    }
}

- (void)animateIncorrectAnswer {
    for (UIButton *slot in self.answerSlots) {
        UIColor *cachedColor = slot.backgroundColor;
        [UIView animateWithDuration:0.1f
                              delay:0.f
                            options:UIViewAnimationOptionAutoreverse
                         animations:^{
                             slot.backgroundColor = [UIColor redColor];
                         } completion:^(BOOL completed) {
                             slot.backgroundColor = cachedColor;
                         }];
    }
}


// otherwise, nothing happens


- (void)removeSlot:(UIButton *)slot {
    // check if current slot is used
    if (!slot.tag == 0) {
        for (int i = 0; i < self.choiceSlots.count; i++){
            UIButton *choice = [self.choiceSlots objectAtIndex:i];
            if (choice.tag == slot.tag) {
                choice.selected = NO;
                [self animate:slot toView:choice];
                
                slot.tag = 0;
                [slot setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
    
    // if yes
    // find matching choice button (based on tag)
    //  re-enable the matching choice button
    //  remove slot, set tag to 0
    // else no
    //  nothing
}

- (NSString *)updateMaxScore {
    return [NSString stringWithFormat:@"Best: %d", [UserData instance].maxScore];
}
@end

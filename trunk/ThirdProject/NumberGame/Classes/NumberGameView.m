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
#import "GameViewController.h"
#import "LevelData.h"

typedef enum {
    ButtonTypeOperator,
    ButtonTypeNumber,
    ButtonTypeNone
} ButtonType;

#define BUFFER_TIME 0.f
#define BUTTON_CORNER_RADIUS (10.f * IPAD_SCALE)

@interface NumberGameView ()

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic) double nextExpireTime;
@property (nonatomic) double maxTime;
@property (nonatomic, retain) UIColor *numberBackgroundColor;
@property (nonatomic, retain) UIColor *operatorBackgroundColor;
@property (nonatomic, retain) UIColor *emptyBackgroundColor;

@property (nonatomic, retain) InGameMessageView *messageView;
@property (nonatomic) int topScore;
@property (nonatomic) BOOL playedTick;
@property (strong, nonatomic) IBOutlet UILabel *topScoreLabel;
@property (nonatomic) double timeLeft;

@end

@implementation NumberGameView

- (void)setup {
    [super setup];
    for (int i = 0; i < self.choiceSlots.count; i++) {
        UIButton *choice = [self.choiceSlots objectAtIndex:i];
        choice.tag = i+1;
    }
    self.playedTick = NO;
    self.maxTime = 10.f;
    
    [self loadUserData];
    self.numberBackgroundColor = [UIColor colorWithRed:84.f/255.f green:255.f/255.f blue:136.f/255.f alpha:1.0f];
    self.operatorBackgroundColor = [UIColor colorWithRed:67.f/255.f green:204.f/255.f blue:109.f/255.f alpha:1.0f];
    self.emptyBackgroundColor = [UIColor colorWithRed:248.f/255.f green:246.f/255.f blue:232.f/255.f alpha:1.0f];
    self.cheatButton.hidden = !DEBUG_MODE;
    [self setupButtons];
}

- (void)setupButtons {
    [self setupMinimumFontSize:self.answerSlots];
    [self setupMinimumFontSize:self.answerSlotsA];
    [self setupMinimumFontSize:self.answerSlotsB];
    [self setupMinimumFontSize:self.choiceSlots];
}

- (void)setupMinimumFontSize:(NSArray *)buttons {
    for (UIButton *button in buttons) {
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.minimumScaleFactor = 0.5f;
    }
}

- (void)refreshGame {
    [self loadUserData];
    self.cheatView.hidden = YES;
    
    LevelData *levelData = [LevelData levelConfigForCurrentScore:[UserData instance].maxScore];
    levelData.answerSlotCount = self.answerSlots.count;
    levelData.choiceSlotCount = self.choiceSlots.count;
    NSDictionary *data = [[NumberManager instance] generateLevel:levelData];
    
    // operator list
    // number range
    int targetValue = [[data objectForKey:@"targetNumber"] intValue];
    NSArray *array = [data objectForKey:@"algebra"];
    [self refreshChoices:array];
    [self resetAnswers];
    self.progressBar.hidden = YES;
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
    [self refreshDisplayAnswers];
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.f target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
}

- (void)loadUserData {
    [UserData instance].maxScore = [[[NSUserDefaults standardUserDefaults] valueForKey:@"maxScore"] intValue];
    self.topScoreLabel.text = [self updateMaxScore];
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
    [UserData instance].lastGameSS = [self blit];
}

-(void)showAnswer {
    self.cheatLabel.hidden = NO;
    NSString *t = @"Answer: ";
    NSMutableArray *newArray = [[NumberManager instance] currentGeneratedAnswerInStrings];
    for (int i = 0; i < newArray.count; i++) {
        t = [NSString stringWithFormat:@"%@ %@",t, [newArray objectAtIndex:i]];
    }
    
    for (NSString *answer in newArray) {
        for (UIButton *choice in self.choiceSlots) {
            NSString *choiceText = [choice titleForState:UIControlStateNormal];
            // matching answer
            BOOL hasSelected = choice.layer.borderWidth > 0;
            if (!hasSelected && [choiceText isEqualToString:answer]) {
                [self showBorder:choice];
                break;
            }
        }
    }
    self.cheatLabel.text = t;
    self.cheatView.hidden = NO;
}

- (void)showBorder:(UIView *)view {
    view.layer.borderColor = [UIColor orangeColor].CGColor;
    view.layer.borderWidth = 2.f * IPAD_SCALE;
}

- (void)hideBorder:(UIView *)view {
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 0.f;
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
        [self.progressBar fillBar:0.f animated:NO];
        [self.timer invalidate];
        [[SoundManager instance] stop:SOUND_EFFECT_TICKING];
        [[SoundManager instance] play:SOUND_EFFECT_WINNING];
        [self hide];
    }
}

- (void)animateAnswersOut {
    if (self.answerSlots.count <= 0) {
        return;
    }
    
    NSMutableArray *allButtons = [NSMutableArray array];
    [allButtons addObject:[self.answerSlots objectAtIndex:0]];
    
    // line up buttons
    for (int i = 2; i < self.answerSlots.count; i += 2) {
        UIButton *opSlot = self.answerSlots[i-1];
        [allButtons addObject:opSlot];
        
        UIButton *rightOperandSlot = self.answerSlots[i];
        [allButtons addObject:rightOperandSlot];
        
        // row 1 = index 0
        int slotDisplayIndex = i / 2 - 1;
        
        if (slotDisplayIndex < self.answerSlotsB.count) {
            UIButton *answerSlotsB = [self.answerSlotsB objectAtIndex:slotDisplayIndex];
            [allButtons addObject:answerSlotsB];
        }
        // row 2 = index 0
        if (slotDisplayIndex < self.answerSlotsA.count) {
            UIButton *answerSlotsA = [self.answerSlotsA objectAtIndex:slotDisplayIndex];
            [allButtons addObject:answerSlotsA];
        }
    }
    
    // animate
    for (int i = 0; i < allButtons.count; i ++) {
        UIButton *button = [allButtons objectAtIndex:i];
        [self animateBlitAndFadeout:button delay:i * 0.1f + 1.5f];
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
        slot.layer.cornerRadius = BUTTON_CORNER_RADIUS;
        [self hideBorder:slot];
    }
}

- (void)resetAnswers {
    for (int i = 0; i < self.answerSlots.count; i++) {
        UIButton *slot = [self.answerSlots objectAtIndex:i];
        slot.tag = 0;
        [slot setTitle:@"" forState:UIControlStateNormal];
    }
    [self refeshAnswerSlotStates];
}

- (void)show {
    self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    self.alpha = 0;
    
    [UIView animateWithDuration:0.3f animations:^ {
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }];
}

- (void)pause {
    [self.timer invalidate];
    self.timer = nil;
     self.timeLeft = (self.nextExpireTime - CACurrentMediaTime());
}

- (void)resume {
    self.nextExpireTime = CACurrentMediaTime() + self.timeLeft + BUFFER_TIME;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.f target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
}

- (IBAction)returnLobby:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.3f, 0.3f);
        self.alpha = 0.0f;
    } completion:^(BOOL complete) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NUMBER_GAME_RETURN_LOBBY_NOTIFICATION object:self];
    }];
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

- (IBAction)answerSlotPressed:(UIButton *)sender {
    [self unhighlightChoiceSlotStates];
    [self removeSlot:sender];
    [self refreshDisplayAnswers];
}

- (IBAction)choiceSlotPressed:(UIButton *)sender {
    [self unhighlightChoiceSlotStates];
    BOOL hasFound = NO;
    for (int i = 0; i < self.answerSlots.count; i++){
        UIButton *answer = [self.answerSlots objectAtIndex:i];
        if (sender.tag == answer.tag) {
            [self removeSlot:answer];
            hasFound = YES;
            break;
        }
    }
    
    if (!hasFound) {
        [self fillSlot:sender];
    } else {
        [self refreshDisplayAnswers];
    }
    [self hidingRows];
}

- (void)animate:(UIView *)fromView toView:(UIView *)toView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[fromView blit]];
    [self addSubview:imageView];
    imageView.frame = [fromView.superview convertRect:fromView.frame toView:self];
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         imageView.frame = [toView.superview convertRect:toView.frame toView:self];
                     } completion:^(BOOL completed) {
                         [UIView animateWithDuration:0.1f
                                               delay:0.f
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              imageView.alpha = 0.0f;
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
                [self highlightChoiceSlotStates];
                [[SoundManager instance]play:SOUND_EFFECT_BOING];
                break;
            }
            
            if (!isOperator && i % 2 == 1) {
                [self highlightChoiceSlotStates];
                [[SoundManager instance]play:SOUND_EFFECT_BOING];
                break;
            }
            [slot setTitle:choiceString forState:UIControlStateNormal];
            //  disable current choice
            
            [self animate:choice toView:slot];
            choice.selected = YES;
            [self showBorder:choice];
            //  set slot with choice's tag (keep reference)
            slot.tag = choice.tag;
            
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
    
    [self refreshDisplayAnswers];
    
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
            [UserData instance].maxScore++;
        }
//        else {
//            [self resetAnswers];
//            [self resetChoices];
//            [[SoundManager instance]play:SOUND_EFFECT_BOING];
//            [self animateIncorrectAnswer];
//
//        }
    }
}

- (void)refreshDisplayAnswers {
    if (self.answerSlots.count <= 0) {
        return;
    }
    
    UIButton *slot = self.answerSlots[0];
    NSString *slotString = [slot titleForState:UIControlStateNormal];
    
    float rowAnswer = [slotString floatValue];
    
    // start index at 1st right operand
    // ex. 1 + 2 - 3 (starts at 2)
    // increment by a group of 2: operator and right operand
    
    for(int i = 2; i < self.answerSlots.count; i += 2) {
        UIButton *opSlot = self.answerSlots[i-1];
        NSString *opString = [opSlot titleForState:UIControlStateNormal];

        UIButton *rightOperandSlot = self.answerSlots[i];
        NSString *rightOperandString = [rightOperandSlot titleForState:UIControlStateNormal];
        float rightOperandValue = [rightOperandString floatValue];
        NSString *rowDisplayString = @"";
        
        // if button is set
        if (opSlot.tag != 0 && rightOperandSlot.tag != 0) {
            rowAnswer = [[NumberManager instance] calculateWithOperandLeft:rowAnswer operator:opString operandRight:rightOperandValue];
            
            NSNumberFormatter *formatter = [self formatterForRowDisplay];
            rowDisplayString = [formatter stringFromNumber:[NSNumber numberWithFloat:rowAnswer]];
        }
        
        // row 1 = index 0
        int slotDisplayIndex = i / 2 - 1;
        
        if (slotDisplayIndex < self.answerSlotsB.count) {
            UIButton *answerSlotsB = [self.answerSlotsB objectAtIndex:slotDisplayIndex];
            [answerSlotsB setTitle:rowDisplayString forState:UIControlStateNormal];
  
            
        }
        // row 2 = index 0
        if (slotDisplayIndex < self.answerSlotsA.count) {
            UIButton *answerSlotsA = [self.answerSlotsA objectAtIndex:slotDisplayIndex];
            [answerSlotsA setTitle:rowDisplayString forState:UIControlStateNormal];
        }
    }
    [self refeshAnswerSlotStates];
}

- (NSNumberFormatter *)formatterForRowDisplay {
    static NSNumberFormatter *formatter = nil;
    
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setAllowsFloats:YES];
        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [formatter setMaximumFractionDigits:1];
    }
    
    return formatter;
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

- (ButtonType)nextFreeButtonType {
    for(int i = 0; i < self.answerSlots.count; i++) {
        UIButton *slot = self.answerSlots[i];
        if (slot.tag == 0) {
            if (i % 2 == 0) {
                return ButtonTypeNumber;
            }
            
            if (i % 2 == 1) {
                return ButtonTypeOperator;
            }
        }
    }
    return ButtonTypeNone;
}

- (void)refeshAnswerSlotStates {
    for (int i = 0; i < self.answerSlots.count; i++) {
        UIButton *slot = [self.answerSlots objectAtIndex:i];
        UIColor *bgColor;
        if (slot.tag == 0) {
            bgColor = self.emptyBackgroundColor;
        } else {
            if (i % 2 == 0) {
                bgColor = self.numberBackgroundColor;
            } else {
                bgColor = self.operatorBackgroundColor;
            }
        }
        slot.backgroundColor = bgColor;
    }
}

- (void)highlightChoiceSlotStates {
    // get the next free button type
    ButtonType nextFreeButtonType = [self nextFreeButtonType];
    // loop through the choices and set the state
    for (int i = 0; i < self.choiceSlots.count; i++){
        UIButton *choice = [self.choiceSlots objectAtIndex:i];
        NSString *choiceString = [choice titleForState:UIControlStateNormal];
        CGFloat alpha = 0.f;
        if ([[NumberManager instance] isOperator:choiceString]) {
            alpha = nextFreeButtonType == ButtonTypeOperator ? 1.0f : 0.3f;
        } else {
            alpha = nextFreeButtonType == ButtonTypeNumber ? 1.0f : 0.3f;
        }
        [UIView animateWithDuration:0.3f animations:^{
            choice.alpha = alpha;
        }];
    }
}

- (void)unhighlightChoiceSlotStates {
    // loop through the choices and set the state
    for (int i = 0; i < self.choiceSlots.count; i++){
        UIButton *choice = [self.choiceSlots objectAtIndex:i];
        [UIView animateWithDuration:0.3f animations:^{
            choice.alpha = 1.0f;
        }];
    }
}

- (void)removeSlot:(UIButton *)slot {
    // check if current slot is used
    if (!slot.tag == 0) {
        for (int i = 0; i < self.choiceSlots.count; i++){
            UIButton *choice = [self.choiceSlots objectAtIndex:i];
            if (choice.tag == slot.tag) {
                choice.selected = NO;
                [self hideBorder:choice];
                [self animate:slot toView:choice];
                
                slot.tag = 0;
                [slot setTitle:@"" forState:UIControlStateNormal];
            }
        }
        [[SoundManager instance] play:SOUND_EFFECT_POP];
    }
    
    // if yes
    // find matching choice button (based on tag)
    //  re-enable the matching choice button
    //  remove slot, set tag to 0
    // else no
    //  nothing
}

- (NSString *)updateMaxScore {
    return [NSString stringWithFormat:@"Level %d", [UserData instance].maxScore];
}

- (void)hidingRows {
    return;
    NSInteger count = self.answerSlotsA.count;
    for (int i = 0; i < count; i++) {
     UIButton *answerSlotsA = [self.answerSlotsA objectAtIndex:i];
        if (![[answerSlotsA titleForState:UIControlStateNormal] isEqual:@""]) {
         UIView *currentview = [self.rowsCollection objectAtIndex:i];
           currentview.alpha = 1.0f;
            }
        }
    
}
- (IBAction)answerSlot3aPressed:(UIButton *)sender {
      return;
    UIView *currentview = [self.rowsCollection objectAtIndex:1];
    currentview.alpha = 1.0f;
}
- (IBAction)answerSlot2aPressed:(UIButton *)sender {
      return;
    UIView *currentview = [self.rowsCollection objectAtIndex:0];
    currentview.alpha = 1.0f;
}
@end

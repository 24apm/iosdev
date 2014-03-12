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
#import "GameCenterHelper.h"
#import "iRate.h"
#import "AnimUtil.h"

typedef enum {
    ButtonTypeOperator,
    ButtonTypeNumber,
    ButtonTypeNone
} ButtonType;

#define BUFFER_TIME 0.f
#define BUTTON_CORNER_RADIUS (10.f * IPAD_SCALE)
#define PENALTY_WAIT_TIME 10.f

@interface NumberGameView ()

@property (nonatomic, retain) UIColor *numberBackgroundColor;
@property (nonatomic, retain) UIColor *operatorBackgroundColor;
@property (nonatomic, retain) UIColor *emptyBackgroundColor;

@property (nonatomic, retain) InGameMessageView *messageView;
@property (nonatomic) int topScore;
@property (strong, nonatomic) IBOutlet UILabel *topScoreLabel;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSDictionary *currentLevelData;
@property (strong, nonatomic) IBOutlet ProgressBarComponent *progressBar;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) double waitTime;
@property (strong, nonatomic) IBOutlet UILabel *demoLabel;

@end

@implementation NumberGameView

- (void)setup {
    [super setup];
    for (int i = 0; i < self.choiceSlots.count; i++) {
        UIButton *choice = [self.choiceSlots objectAtIndex:i];
        choice.tag = i+1;
    }
    
    [self loadUserData];
    self.numberBackgroundColor = [UIColor colorWithRed:84.f/255.f green:255.f/255.f blue:136.f/255.f alpha:1.0f];
    self.operatorBackgroundColor = [UIColor colorWithRed:67.f/255.f green:204.f/255.f blue:109.f/255.f alpha:1.0f];
    self.emptyBackgroundColor = [UIColor colorWithRed:248.f/255.f green:246.f/255.f blue:232.f/255.f alpha:1.0f];
    [self setupButtons];
    [self refreshCheatButton];
    self.userTries = 3;
}

- (void)refreshCheatButton {
    self.activityIndicatorView.hidden = YES;
    self.products = [NumberGameIAPHelper sharedInstance].products;
    if (!self.products) {
        self.cheatButton.hidden = YES;
    } else {
        self.cheatButton.hidden = NO;
    }
    if (DEBUG_MODE) {
        self.cheatButton.hidden = NO;
    }
    
    if ([self loadCheatCount] > 0) {
        [self showAnswer];
        self.cheatButton.enabled = NO;
        self.cheatButton.alpha = 0.5f;
    } else {
        self.cheatButton.enabled = YES;
        self.cheatButton.alpha = 1.f;
    }
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
    self.userInteractionEnabled = YES;
    [self loadUserData];
    self.cheatView.hidden = YES;
    self.demoLabel.hidden = YES;
    self.userTries = 3;
    
    if ([UserData instance].tutorialModeEnabled) {
        self.userInteractionEnabled = NO;
        self.currentLevelData = [self generateTutorialLevel];
        self.demoLabel.hidden = NO;
    } else {
        self.currentLevelData = [self loadLevelData];
        if (!self.currentLevelData) {
            self.currentLevelData = [self generateLevel];
            [self cacheLevelData:self.currentLevelData];
        }
    }
    
    // operator list
    // number range
    int targetValue = [[self.currentLevelData objectForKey:@"targetNumber"] intValue];
    NSArray *array = [self.currentLevelData objectForKey:@"algebra"];
    [self refreshChoices:array];
    [self resetAnswers];
    self.targetNumberLabel.text = [NSString stringWithFormat:@"%d",targetValue];
    self.cheatLabel.hidden = YES;
    self.progressBar.hidden = YES;
    [self refreshDisplayAnswers];
    
    if ([UserData instance].tutorialModeEnabled) {
        [self performSelector:@selector(playTutorial) withObject:nil afterDelay:1.0f];
    } else {
        [self refreshCheatButton];
    }
}

- (NSDictionary *)generateLevel {
    LevelData *levelData = [LevelData levelConfigForCurrentScore:[UserData instance].maxScore];
    levelData.answerSlotCount = self.answerSlots.count;
    levelData.choiceSlotCount = self.choiceSlots.count;
    return [[NumberManager instance] generateLevel:levelData];
}

- (NSDictionary *)generateTutorialLevel {
    LevelData *levelData = [LevelData levelConfigForCurrentScore:0];
    levelData.answerSlotCount = self.answerSlots.count;
    levelData.choiceSlotCount = self.choiceSlots.count;
    return [[NumberManager instance] generateLevel:levelData];
}

- (void)cacheLevelData:(NSDictionary *)levelData {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:levelData forKey:@"currentLevelData"];
    [defaults synchronize];
}

- (NSDictionary *)loadLevelData {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"currentLevelData"];
}

- (void)incrementCheatCount {
    NSInteger cheatCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"cheat"];
    cheatCount++;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:cheatCount forKey:@"cheat"];
    [defaults synchronize];
}

- (void)penaltyWait {
    self.waitTime = CACurrentMediaTime() + PENALTY_WAIT_TIME;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.f target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
    [self updateProgressBar];
    self.buttonLayerView.alpha = 0.5f;
    self.userInteractionEnabled = NO;
    self.progressBar.hidden = NO;
}

- (void)updateProgressBar {
    double percentage = 1.0f-(self.waitTime - CACurrentMediaTime()) / PENALTY_WAIT_TIME;
   // NSLog(@"percentage %0.2f", percentage);
    if (percentage < 1.f) {
        [self.progressBar fillBar:percentage animated:NO];
        if (percentage > 0.33f && self.userTries <= 0) {
            self.userTries++;
        }
        if (percentage > 0.66f && self.userTries <= 1) {
            self.userTries++;
        }
        if (percentage > 0.99f && self.userTries <= 2) {
            self.userTries++;
        }
    } else {
        self.userTries = 3;
        self.buttonLayerView.alpha = 1.0f;
        self.userInteractionEnabled = YES;
        [self.timer invalidate];
        self.progressBar.hidden = YES;
    }
}

- (void)flashError {
    //[self flash];
    [AnimUtil wobble:self duration:0.1f angle:M_PI/128.f];
    [[SoundManager instance] play:SOUND_EFFECT_BOING];
}

- (void)flash {
    float duration = 0.2f;
    UIView *flashOverlay = [[UIView alloc] init];
    [self addSubview:flashOverlay];
    flashOverlay.backgroundColor = [UIColor whiteColor];
    flashOverlay.frame = self.bounds;
    flashOverlay.alpha = 0.f;
    [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionLayoutSubviews animations:^{
        flashOverlay.alpha = 1.0f;
    } completion:^(BOOL completed){
        [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionLayoutSubviews animations:^{
        } completion:^(BOOL completed){
            [flashOverlay removeFromSuperview];
        } ];
    } ];
}

- (void)decrementTries {
    self.userTries = self.userTries - 1;
    [self flashError];
    if (self.userTries < 1) {
        self.userTries = 0;
        [self penaltyWait];

    }
}
- (void)decrementCheatCount {
    NSInteger cheatCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"cheat"];
    cheatCount--;
    if (cheatCount < 0) {
        cheatCount = 0;
    }
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setInteger:cheatCount forKey:@"cheat"];
    [defaults synchronize];
}


- (NSInteger)loadCheatCount {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"cheat"];
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

#pragma mark - iAP
- (IBAction)cheatPressed:(id)sender {
    if (DEBUG_MODE) {
        [self showAnswer];
        [self incrementCheatCount];
    } else {
        for (SKProduct *product in self.products) {
            if ([product.productIdentifier isEqualToString:IAP_UNLOCK_ANSWER]) {
                self.userInteractionEnabled = NO;
                NSLog(@"Buying %@...", product.productIdentifier);
                self.activityIndicatorView.hidden = NO;
                [self.activityIndicatorView startAnimating];
                [[NumberGameIAPHelper sharedInstance] buyProduct:product];
            }
        }
    }
}

- (void)productPurchased:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    if (productIdentifier) {
        // Unlock answer
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
        self.userInteractionEnabled = YES;
        [self incrementCheatCount];
        [self showAnswer];
    }
}

- (void)productFailed:(NSNotification *)notification {
    self.userInteractionEnabled = YES;
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidden = YES;
}

-(void)showAnswer {
    [self resetChoices];
    self.cheatLabel.hidden = NO;
    NSString *t = @"Answer: ";
    NSMutableArray *newArray = [self.currentLevelData objectForKey:@"currentGeneratedAnswerInStrings"];
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

- (void)playTutorial {
    self.userInteractionEnabled = NO;
    float delay = 0.f;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *newArray = [self.currentLevelData objectForKey:@"currentGeneratedAnswerInStrings"];
    for (NSString *answer in newArray) {
        for (UIButton *choice in self.choiceSlots) {
            NSString *choiceText = [choice titleForState:UIControlStateNormal];
            // matching answer
            if (![dict valueForKey:[NSString stringWithFormat:@"%d", choice.tag]]) {
                if ([choiceText isEqualToString:answer]) {
                    [dict setValue:@(YES) forKey:[NSString stringWithFormat:@"%d", choice.tag]];
                    [self performSelector:@selector(fillSlot:) withObject:choice afterDelay:delay];
                    delay += 1.f;
                    break;
                }
            }
        }
    }
    [self performSelector:@selector(resetUserInteractionEnabledAfterDelay) withObject:nil afterDelay:delay];
    newArray = nil;
}

- (void)resetUserInteractionEnabledAfterDelay {
    self.userInteractionEnabled = YES;
}

- (void)showBorder:(UIView *)view {
    view.layer.borderColor = [UIColor orangeColor].CGColor;
    view.layer.borderWidth = 2.f * IPAD_SCALE;
}

- (void)hideBorder:(UIView *)view {
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 0.f;
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
        slot.hidden = NO;
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


#pragma mark - show and hide
- (void)show {
    self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    self.alpha = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productFailed:) name:IAPHelperProductFailedNotification object:nil];
    
    [UIView animateWithDuration:0.3f animations:^ {
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }];
    
    
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
    // disabled tapping choice to unselect because it causes confusion
    //    for (int i = 0; i < self.answerSlots.count; i++){
    //        UIButton *answer = [self.answerSlots objectAtIndex:i];
    //        if (sender.tag == answer.tag) {
    //            [self removeSlot:answer];
    //            hasFound = YES;
    //            break;
    //        }
    //    }
    
    if (!hasFound && [self hasEmptyInSlots]) {
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
            choice.hidden = YES;
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
            if ([UserData instance].tutorialModeEnabled) {
                [self tutorialEndGame];
            } else {
                [self endGame];
            }
        } else {
            [self decrementTries];
            [self performSelector:@selector(animateIncorrectAnswer) withObject:nil afterDelay:0.f];
            [self performSelector:@selector(animateIncorrectAnswer) withObject:nil afterDelay:0.2f];
            [self performSelector:@selector(animateIncorrectAnswer) withObject:nil afterDelay:0.4f];
            
            [[SoundManager instance]play:SOUND_EFFECT_BOING];
        }
    }
}

- (BOOL)hasEmptyInSlots {
    BOOL hasEmpty = NO;
    for(int i = 0; i < self.answerSlots.count; i++) {
        UIButton *slot = self.answerSlots[i];
        if (slot.tag == 0) {
            hasEmpty = YES;
            break;
        } else {
            hasEmpty = NO;
        }
    }
    return hasEmpty;
}
- (void)endGame {
    self.userInteractionEnabled = NO;
    [self animateAnswersOut];
    [self showMessageView];
    [self resetAnswers];
    [self refreshDisplayAnswers];
    [UserData instance].maxScore++;
    [[iRate sharedInstance] logEvent:NO];
    [self decrementCheatCount];
    [[SoundManager instance] play:SOUND_EFFECT_BLING];
    [self performSelector:@selector(checkAchievements) withObject:nil afterDelay:1.2f];
    [self performSelector:@selector(newGame) withObject:nil afterDelay:3.2f];
}

- (void)tutorialEndGame {
    self.userInteractionEnabled = NO;
    [self showMessageView];
    [self performSelector:@selector(returnLobby:) withObject:nil afterDelay:3.2f];
    [UserData instance].tutorialModeEnabled = NO;
}

- (void)checkAchievements {
    [[GameCenterHelper instance] checkAchievements];
}

- (void)newGame {
    [self cacheLevelData:[self generateLevel]];
    [self refreshGame];
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
            //            answerSlotsB.hidden = [rowDisplayString isEqualToString:@""];
        }
        
        if (slotDisplayIndex < self.equalSignsCollection.count) {
            UILabel *equalSign = [self.equalSignsCollection objectAtIndex:slotDisplayIndex];
            equalSign.hidden = [rowDisplayString isEqualToString:@""];
        }
        
        // row 2 = index 0
        if (slotDisplayIndex < self.answerSlotsA.count) {
            UIButton *answerSlotsA = [self.answerSlotsA objectAtIndex:slotDisplayIndex];
            [answerSlotsA setTitle:rowDisplayString forState:UIControlStateNormal];
            //            answerSlotsA.hidden = [rowDisplayString isEqualToString:@""];
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

- (void) setUserTries:(int)userTries {
    _userTries = userTries;
    [self refreshHearts];
}

-(void) refreshHearts {
    int refreshNum = self.userTries;
    for (int i = 0; i < refreshNum; i++) {
      UIImageView *temp = [self.hearts objectAtIndex:i];
        temp.hidden = NO;
    }
    
    for (int i = refreshNum; i < self.hearts.count; i++) {
        UIImageView *temp = [self.hearts objectAtIndex:i];
        temp.hidden = YES;
    }
}

- (void)animateIncorrectAnswer {
    UIButton *lastAnswerButton = [self.answerSlotsB lastObject];
    [UIView animateWithDuration:0.15f
                          delay:0.f
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{
                         lastAnswerButton.backgroundColor = [UIColor redColor];
                     } completion:^(BOOL completed) {
                         lastAnswerButton.backgroundColor = self.emptyBackgroundColor;
                     }];
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
                choice.hidden = NO;
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

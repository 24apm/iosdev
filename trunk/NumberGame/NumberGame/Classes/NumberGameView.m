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

@interface NumberGameView ()

//@property (nonatomic) int answerSlotsNum;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic) double nextExpireTime;
@property (nonatomic) double maxTime;
@property (nonatomic, retain) UIColor *numberBackgroundColor;
@property (nonatomic, retain) UIColor *operatorBackgroundColor;
@property (nonatomic, retain) InGameMessageView *messageView;

@end

@implementation NumberGameView

- (void)setup {
    [super setup];
    for (int i = 0; i < self.choiceSlots.count; i++) {
        UIButton *choice = [self.choiceSlots objectAtIndex:i];
        choice.tag = i+1;
    }
    
    self.maxTime = 30.f;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
    
    self.numberBackgroundColor = [UIColor colorWithRed:84.f/255.f green:255.f/255.f blue:136.f/255.f alpha:1.0f];
    self.operatorBackgroundColor = [UIColor colorWithRed:67.f/255.f green:204.f/255.f blue:109.f/255.f alpha:1.0f];
    
    
    self.messageView = [[InGameMessageView alloc] init];
    [self addSubview:self.messageView];
    self.messageView.frame = self.frame;
    self.messageView.hidden = YES;
}

- (IBAction)cheatPressed:(id)sender {
    self.cheatLabel.hidden = !self.cheatLabel.hidden;
    
    NSString *myString = [NSString stringWithFormat:@"%@", [[NumberManager instance] currentGeneratedAnswer]];
    NSString *newString = [[myString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];

    self.cheatLabel.text = newString;
}

- (void)updateProgressBar {
    float percentage = (self.nextExpireTime - CACurrentMediaTime()) / self.maxTime;

    if (percentage > 0) {
        [self.progressBar fillBar:percentage animated:YES];
    } else {
        [self.progressBar fillBar:0.f animated:YES];
        [self.timer invalidate];
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
    self.targetNumberLabel.text = [NSString stringWithFormat:@"%d",targetValue];
    
    self.nextExpireTime = CACurrentMediaTime() + self.maxTime;
    self.cheatLabel.hidden = YES;
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
        [slot setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        slot.layer.cornerRadius = slot.height * 0.1f;
    }
}

- (void)resetAnswers {
    for (int i = 0; i < self.answerSlots.count; i++) {
        UIButton *slot = [self.answerSlots objectAtIndex:i];
        slot.tag = 0;
        [slot setTitle:@"?" forState:UIControlStateNormal];
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
    [UIView animateWithDuration:0.3f animations:^ {
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }];
    [self refreshGame];
}

- (void)hide {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
        self.alpha = 0.0f;
    } completion:^(BOOL complete) {
        //        [[NSNotificationCenter defaultCenter] postNotificationName:MAIN_VIEW_DISMISSED_NOTIFICATION object:self];
        //
    }];
}


- (IBAction)answerSlotPressed:(UIButton *)sender {
    [self removeSlot:sender];
}

- (IBAction)choiceSlotPressed:(UIButton *)sender {
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
        if ([slot.titleLabel.text isEqualToString:@"?"]) {
            if (isOperator && i % 2 == 0) {
                [self animateIncorrectAnswer];
                break;
            }
            
            if (!isOperator && i % 2 == 1) {
                [self animateIncorrectAnswer];
                break;
            }
            [slot setTitle:choiceString forState:UIControlStateNormal];
            //  disable current choice
            
            [choice setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            //  set slot with choice's tag (keep reference)
            slot.tag = choice.tag;
            
            
            [self animate:choice toView:slot];
            break;
        }
    }
    
    BOOL hasEmpty = NO;
    for(int i = 0; i < self.answerSlots.count; i++) {
        UIButton *slot = self.answerSlots[i];
        if ([[slot titleForState:UIControlStateNormal] isEqualToString:@"?"]) {
            hasEmpty = YES;
        } else {
            [algebra addObject:[slot titleForState:UIControlStateNormal]];
        }
    }
    if (hasEmpty == NO){
        float targetValue = [self.targetNumberLabel.text floatValue];
        BOOL isCorrect =[[NumberManager instance] checkAlgebra:algebra targetValue:targetValue];
        if (isCorrect) {
            [self.messageView show];
            [self refreshGame];
        } else {
            [self animateIncorrectAnswer];
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
    if (![slot.titleLabel.text isEqualToString:@"?"]) {
        for (int i = 0; i < self.choiceSlots.count; i++){
            UIButton *choice = [self.choiceSlots objectAtIndex:i];
            if (choice.tag == slot.tag) {
                [choice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self animate:slot toView:choice];

                slot.tag = 0;
                [slot setTitle:@"?" forState:UIControlStateNormal];
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

@end

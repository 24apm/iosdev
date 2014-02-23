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

@interface NumberGameView ()

//@property (nonatomic) int answerSlotsNum;

@end

@implementation NumberGameView

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [super setup];
    for (int i = 0; i < self.choiceSlots.count; i++) {
        UIButton *choice = [self.choiceSlots objectAtIndex:i];
        choice.tag = i+1;
    }
}

- (void)refreshGame {
    // self.answerSlotsNum = 0;
    //int maxNumberRange = 10;
    NSDictionary *data = [[NumberManager instance] generateLevel];
    int targetValue = [[data objectForKey:@"targetNumber"] intValue];
    NSArray *array = [data objectForKey:@"algebra"];
    self.targetNumberLabel.text = [NSString stringWithFormat:@"%d",targetValue];
    for(int i = 0; i < self.choiceSlots.count; i++) {
        UIButton *slot = [self.choiceSlots objectAtIndex:i];
        NSString *arrayTitle;
            if ([array[i] isKindOfClass: [NSNumber class]]) {
                arrayTitle = [NSString stringWithFormat:@"%d", [((NSNumber *)array[i])intValue]];
            } else{
                arrayTitle = array[i];
            }
            [slot setTitle:arrayTitle forState:UIControlStateNormal];
        
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
    //    NSString *resetting = @"?";
    //    if (self.answerSlotsNum > 2) {
    //        self.answerSlotsNum = 2;
    //    }
    //    if (self.answerSlotsNum >= 0 && ![sender.titleLabel.text isEqualToString:@"?"]) {
    //        UIButton *slot = self.answerSlots[self.answerSlotsNum];
    //        [slot setTitle:resetting forState:UIControlStateNormal];
    //        self.answerSlotsNum--;
    //    }
    //
    [self removeSlot:sender];
}

- (IBAction)choiceSlotPressed:(UIButton *)sender {
    //    NSString *chosenNumber = sender.titleLabel.text;
    //    if (self.answerSlotsNum < 3) {
    //    UIButton *slot = self.answerSlots[self.answerSlotsNum];
    //    [slot setTitle:chosenNumber forState:UIControlStateNormal];
    //    self.answerSlotsNum++;
    //    }
    
    [self fillSlot:sender];
}

- (void)fillSlot:(UIButton *)choice {
    // find first empty slot
    NSMutableArray *algebra = [NSMutableArray array];
    for(int i = 0; i < self.answerSlots.count; i++) {
        UIButton *slot = self.answerSlots[i];
        // fill the slot with choice button if there is one
        if ([slot.titleLabel.text isEqualToString:@"?"]) {
            [slot setTitle:[choice titleForState:UIControlStateNormal] forState:UIControlStateNormal];
            //  disable current choice
            
            choice.enabled = NO;
            //  set slot with choice's tag (keep reference)
            slot.tag = choice.tag;
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
            [self refreshGame];
        }
    }
}


// otherwise, nothing happens


- (void)removeSlot:(UIButton *)slot {
    // check if current slot is used
    if (![slot.titleLabel.text isEqualToString:@"?"]) {
        for (int i = 0; i < self.choiceSlots.count; i++){
            UIButton *choice = [self.choiceSlots objectAtIndex:i];
            if (choice.tag == slot.tag) {
                choice.enabled = YES;
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

//
//  NumberGameView.h
//  NumberGame
//
//  Created by MacCoder on 2/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "ProgressBarComponent.h"

#define NUMBER_GAME_CALLBACK_NOTIFICATION @"NUMBER_GAME_CALLBACK_NOTIFICATION"
#define NUMBER_GAME_RETURN_LOBBY_NOTIFICATION @"NUMBER_GAME_RETURN_LOBBY_NOTIFICATION"

@interface NumberGameView : XibView

- (IBAction)answerSlotPressed:(UIButton *)sender;
- (IBAction)choiceSlotPressed:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILabel *targetNumberLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerSlots;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *choiceSlots;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *rowsCollection;

@property (strong, nonatomic) IBOutlet UIButton *cheatButton;
@property (strong, nonatomic) IBOutlet UILabel *cheatLabel;
@property (strong, nonatomic) IBOutlet UILabel *scores;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
@property (strong, nonatomic) IBOutlet UIView *cheatView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerSlotsA;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerSlotsB;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *equalSignsCollection;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (void)show;
- (void)refreshGame;
- (void)showAnswer;

@end

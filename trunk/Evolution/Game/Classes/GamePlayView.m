//
//  NumberGameView.m
//  NumberGame
//
//  Created by MacCoder on 2/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GamePlayView.h"
#import "GameConstants.h"
#import "SoundManager.h"
#import "UserData.h"
#import "AnimUtil.h"
#import "PromoDialogView.h"

#define BUFFER 3

@interface GamePlayView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) CFTimeInterval startingTime;
@property (nonatomic) double finalTime;
@property (nonatomic, strong) UIView* currentChoice;

@end

@implementation GamePlayView

- (IBAction)replayButtonPressed:(UIButton *)sender {
    [self show];
}

- (IBAction)returnButtonPressed:(UIButton *)sender {
    [self hide];
}

- (void)show {
    self.replayButton.hidden = YES;
    self.returnButton.hidden = YES;
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }]; 
    [self startGame];
}

- (void)startGame {
    [self.gameLayoutView generateNewBoard];
}

- (void)refreshGame {
    
}

- (void)hide {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
        self.alpha = 0.0f;
    } completion:^(BOOL complete) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GAMEPLAY_VIEW_DISMISSED_NOTIFICATION object:self];
    }];
}


- (void)endGame {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     self.userInteractionEnabled = YES;
    self.replayButton.hidden = NO;
    self.returnButton.hidden = NO;
}

@end

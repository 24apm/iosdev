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
#import "PromoDialogView.h"

#define TIMES_PLAYED_BEFORE_PROMO 3
#define BUFFER 3

@interface GamePlayView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) CFTimeInterval startingTime;
@property (nonatomic) double finalTime;
@property (nonatomic, strong) UIView* currentChoice;

@end

@implementation GamePlayView

static int promoDialogInLeaderBoardCount = 0;

- (id)init {
    self = [super init];
    if (self) {
      //  self.gameLayoutView.timeLabel.textColor = kCOLOR_RED;
    }
    return self;
}
- (IBAction)replayButtonPressed:(UIButton *)sender {
    [self show];
}

- (IBAction)returnButtonPressed:(UIButton *)sender {
    [self hide];
}

- (void)show {
 //   [self.gameLayoutView wobbleUnits];
    self.replayButton.hidden = YES;
    self.returnButton.hidden = YES;
    self.startingTime = 0;
     self.userInteractionEnabled = YES;

    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }]; 
    //self.userInteractionEnabled = YES;
    float delay = 5.8f;
    [self performSelector:@selector(startGame) withObject:nil afterDelay:delay];

}

- (void)startGame {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startGame) object:nil];
    float delay = [Utils randBetweenMin:5.f max:10.f];
    [self performSelector:@selector(renewGame) withObject:nil afterDelay:delay];
}

- (void)hide {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
        self.alpha = 0.0f;
    } completion:^(BOOL complete) {
        [self resetting];
        [[NSNotificationCenter defaultCenter] postNotificationName:GAMEPLAY_VIEW_DISMISSED_NOTIFICATION object:self];
    }];
}

- (void)renewGame{
    [[GameManager instance] resetScore];
 
}

- (void)refreshGameCallback {
    [self refreshGame];
}

- (void)refreshGame {
    //NSArray *visibleUnits = [[GameManager instance] currentVisibleQueue];
    //[self.gameLayoutView updateUnitViews:visibleUnits];
}

- (void)leftPressedCallback {
 
}


- (void)rightPressedCallback {

}

- (void)endGame {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     self.userInteractionEnabled = YES;
    self.replayButton.hidden = NO;
    self.returnButton.hidden = NO;
}

- (void)lostGame {
 
}

- (void)showPromoDialog {
    promoDialogInLeaderBoardCount++;
    
    if (promoDialogInLeaderBoardCount % TIMES_PLAYED_BEFORE_PROMO == 0) {
        [PromoDialogView show];
    }
}

- (NSString *)formatTimeString:(float)time {
    return [NSString stringWithFormat:@"%.3F", time];
}

- (void)victoryGame {
 
}

- (void)resetting {
    self.currentChoice = nil;
}

- (void)winAnimation {

}


@end

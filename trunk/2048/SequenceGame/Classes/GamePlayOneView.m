//
//  NumberGameView.m
//  NumberGame
//
//  Created by MacCoder on 2/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GamePlayOneView.h"
#import "GameManager.h"
#import "MonsterView.h"
#import "GameConstants.h"
#import "SoundManager.h"
#import "UserData.h"
#import "AnimUtil.h"
#import "PromoDialogView.h"

#define TIMES_PLAYED_BEFORE_PROMO 2
#define BUFFER 3

@interface GamePlayOneView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) CFTimeInterval startingTime;
@property (nonatomic) double finalTime;
@property (nonatomic, strong) UIView *currentChoice;
@property (nonatomic, strong) NSString *gender;

@end

@implementation GamePlayOneView

static int promoDialogInLeaderBoardCount = 0;

- (id)init {
    self = [super init];
    if (self) {
       // self.gameLayoutView.timeLabel.textColor = kCOLOR_RED;
        [self.gameLayoutView setupDefault];
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
    [self.gameLayoutView restoreDefault];
    self.replayButton.hidden = YES;
    self.returnButton.hidden = YES;
    self.startingTime = 0;
    //self.gender = [self randomPerson];
    //[self setupWithGender];
    self.userInteractionEnabled = YES;
    self.gameLayoutView.timeLabel.text = [NSString stringWithFormat:@"0.000"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGameCallback) name:GAME_MANAGER_REFRESH_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(victoryGame) name:GAMEPLAY_VIEW_VICTORY_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftPressedCallback) name:NOTIFICATION_GAME_LAYOUT_VIEW_LEFT_BUTTON_PRESSED object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightPressedCallback) name:NOTIFICATION_GAME_LAYOUT_VIEW_RIGHT_BUTTON_PRESSED object:nil];

    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }]; 
    float delay = [Utils randBetweenMin:10.f max:16.f];
    [self.gameLayoutView introduction];
    [self performSelector:@selector(renewGame) withObject:nil afterDelay:delay];
}

- (void)hide {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
        self.alpha = 0.0f;
    } completion:^(BOOL complete) {
        [self resetting];
        [[NSNotificationCenter defaultCenter] postNotificationName:GAMEPLAY_ONE_VIEW_DISMISSED_NOTIFICATION object:self];
    }];
}

- (void)renewGame{
    [[GameManager instance] resetScore];
    [self startTime];
}

- (void)refreshGameCallback {
    [self refreshGame];
}

- (void)refreshGame {
    //NSArray *visibleUnits = [[GameManager instance] currentVisibleQueue];
    //[self.gameLayoutView updateUnitViews:visibleUnits];
}

- (void)leftPressedCallback {
    // tell manager to dosomething with action
    self.currentChoice = self.gameLayoutView.female;
    if (self.timer != nil) {
        [self stopTime];
        [self victoryGame];
    } else {
        [self lostGame];
    }
   // [self.gameLayoutView gameplayEnd];
}


- (void)rightPressedCallback {
    self.currentChoice = self.gameLayoutView.male;
    if (self.timer != nil) {
        [self stopTime];
        [self victoryGame];
    } else {
        [self lostGame];
    }
   // [self.gameLayoutView gameplayEnd];
}

- (void)startTime {
    [self.gameLayoutView roundStart];
    self.startingTime = CACurrentMediaTime();
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/15.f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)updateTimer {
    double currentTime = CACurrentMediaTime() - self.startingTime;
    self.gameLayoutView.timeLabel.text = [NSString stringWithFormat:@"%.3F", currentTime];
}

- (void)endGame {
    [self hide];
}

- (void)stopTime {
    if (self.timer != nil) {
        [self.timer invalidate]; self.timer = nil;
        self.finalTime = CACurrentMediaTime() - self.startingTime;
        self.gameLayoutView.timeLabel.text = [self formatTimeString:self.finalTime];
    }

}

- (void)lostGame {
     self.userInteractionEnabled = NO;
    self.gameLayoutView.timeLabel.hidden = YES;
    [self.gameLayoutView animateMovingToDoorFor:self.currentChoice];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(renewGame) object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //self.userInteractionEnabled = NO;
    [self.gameLayoutView performSelector:@selector(animateLostView) withObject:nil afterDelay:0.3f];
    [self performSelector:@selector(lostAnimation) withObject:nil afterDelay:0.3f];
    [self performSelector:@selector(endGame) withObject:nil afterDelay:2.0f];
    [self performSelector:@selector(showPromoDialog) withObject:nil afterDelay:2.5f];
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
    self.userInteractionEnabled = NO;
    promoDialogInLeaderBoardCount = 0; // reset promo
    [[UserData instance] addNewScoreLocalLeaderBoard:self.finalTime mode:[GameManager instance].gameMode];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.gameLayoutView animateMovingToDoorFor:self.currentChoice];
    [self performSelector:@selector(winAnimation) withObject:nil afterDelay:0.4f];
      [self performSelector:@selector(displayWinner) withObject:nil afterDelay:0.8f];
    [self.gameLayoutView flash];
    [[SoundManager instance] play:SOUND_EFFECT_WINNING];
    [self performSelector:@selector(endGame) withObject:nil afterDelay:3.0f];
}

- (void)resetting {
    self.currentChoice = nil;
    [self.gameLayoutView restoreDefault];
}

- (void)winAnimation {
    self.gameLayoutView.person.hidden = YES;
    [self.gameLayoutView animateMovingAwayfromDoorFor:self.gameLayoutView.person];
    self.gameLayoutView.doorAfter.hidden = NO;
    self.gameLayoutView.door.hidden = YES;
}

- (void)lostAnimation {
    self.currentChoice.hidden = YES;
    [self.gameLayoutView animateMovingAwayfromDoorFor:self.currentChoice];
}

- (void)displayWinner {
    [self.gameLayoutView showMessageView:@"You\nWin!"];
}

@end
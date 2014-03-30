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

#define BUFFER 3

@interface GamePlayView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) CFTimeInterval startingTime;
@property (nonatomic) double finalTime;
@property (nonatomic, strong) UIView* currentChoice;

@end

@implementation GamePlayView

- (id)init {
    self = [super init];
    if (self) {
        self.gameLayoutView.timeLabel.textColor = kCOLOR_RED;
        [self.gameLayoutView setupDefault];
    }
    return self;
}

- (void)show {
 //   [self.gameLayoutView wobbleUnits];
    self.startingTime = 0;
    self.gameLayoutView.timeLabel.text = [NSString stringWithFormat:@"0.00"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGameCallback) name:GAME_MANAGER_REFRESH_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(victoryGame) name:GAMEPLAY_VIEW_VICTORY_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftPressedCallback) name:NOTIFICATION_GAME_LAYOUT_VIEW_LEFT_BUTTON_PRESSED object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightPressedCallback) name:NOTIFICATION_GAME_LAYOUT_VIEW_RIGHT_BUTTON_PRESSED object:nil];

    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }];
    self.gameLayoutView.timeLabel.hidden = NO;
    self.userInteractionEnabled = YES;
    float delay = [Utils randBetweenMin:1.f max:6.f];
    [self performSelector:@selector(renewGame) withObject:nil afterDelay:delay];
}

- (void)hide {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
        self.alpha = 0.0f;
    } completion:^(BOOL complete) {
        [self.gameLayoutView removeWobbleUnits];
        [[NSNotificationCenter defaultCenter] postNotificationName:GAMEPLAY_VIEW_DISMISSED_NOTIFICATION object:self];
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
        [[GameManager instance] addScore:UserInputDefend];
        [self victoryGame];
    } else {
        [self lostGame];
    }
}


- (void)rightPressedCallback {
    self.currentChoice = self.gameLayoutView.male;
    if (self.timer != nil) {
        [[GameManager instance] addScore:UserInputAttack];
        [self victoryGame];
    } else {
        [self lostGame];
    }

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
    [self performSelector:@selector(resetting) withObject:nil afterDelay:3.0f];
}

- (void)stopTime {
    if (self.timer != nil) {
        [self.timer invalidate]; self.timer = nil;
        self.finalTime = CACurrentMediaTime() - self.startingTime;
        self.gameLayoutView.timeLabel.text = [self formatTimeString:self.finalTime];
    }

}

- (void)lostGame {
    self.gameLayoutView.timeLabel.hidden = YES;
    [self.gameLayoutView animateMovingToDoorFor:self.currentChoice];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(renewGame) object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.userInteractionEnabled = NO;
    [self.gameLayoutView performSelector:@selector(animateLostView) withObject:nil afterDelay:0.3f];
    [self performSelector:@selector(lostAnimation) withObject:nil afterDelay:0.3f];
    [self performSelector:@selector(endGame) withObject:nil afterDelay:2.0f];
}

- (NSString *)formatTimeString:(float)time {
    return [NSString stringWithFormat:@"%.3F", time];
}

- (void)victoryGame {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.gameLayoutView animateMovingToDoorFor:self.currentChoice];
    self.userInteractionEnabled = NO;
    [self performSelector:@selector(winAnimation) withObject:nil afterDelay:0.4f];
      [self performSelector:@selector(displayWinner) withObject:nil afterDelay:0.8f];
    [self stopTime];
    [self.gameLayoutView flash];
     //  [self.gameLayoutView showMessageView:@"Good Work!"];
    [[SoundManager instance] play:SOUND_EFFECT_WINNING];
    [self performSelector:@selector(endGame) withObject:nil afterDelay:3.0f];
}

- (void)resetting {
    self.currentChoice = nil;
    [self.gameLayoutView restoreDefault];
    self.gameLayoutView.male.hidden = NO;
    self.gameLayoutView.female.hidden = NO;
    self.gameLayoutView.person.hidden = NO;
    self.gameLayoutView.door.image = [UIImage imageNamed:@"doorsPerson"];
    self.gameLayoutView.doorAfter.hidden = YES;
    self.gameLayoutView.door.hidden = NO;
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
    Winner winner = [[GameManager instance] calculateWinner];
    switch (winner) {
        case PlayerOneWin:
            [self.gameLayoutView showMessageView:@"Player One\nWin!"];
            break;
        case PlayerTwoWin:
            [self.gameLayoutView showMessageView:@"Player Two\nWin!"];
            break;
        case Tie:
            [self.gameLayoutView showMessageView:@"Tie Game!"];
            break;
        default:
            break;
    }
}
@end

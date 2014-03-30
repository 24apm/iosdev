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

@end

@implementation GamePlayView

- (id)init {
    self = [super init];
    if (self) {
        self.gameLayoutView.timeLabel.textColor = kCOLOR_RED;
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
    if (self.timer != nil) {
        [[GameManager instance] addScore:UserInputDefend];
        [self victoryGame];
    } else {
        [self lostGame];
    }
}


- (void)rightPressedCallback {
    if (self.timer != nil) {
        [[GameManager instance] addScore:UserInputAttack];
        [self victoryGame];
    } else {
        [self lostGame];
    }

}

- (void)startTime {
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
    self.gameLayoutView.timeLabel.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(renewGame) object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.userInteractionEnabled = NO;
    [self.gameLayoutView performSelector:@selector(animateLostView) withObject:nil afterDelay:0.5f];
    [self performSelector:@selector(endGame) withObject:nil afterDelay:2.0f];
}

- (NSString *)formatTimeString:(float)time {
    return [NSString stringWithFormat:@"%.3F", time];
}

- (void)victoryGame {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.gameLayoutView animateEnding];
    self.userInteractionEnabled = NO;
    [self stopTime];
    [self.gameLayoutView flash];
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
  //  [self.gameLayoutView showMessageView:@"Good Work!"];
    [[SoundManager instance] play:SOUND_EFFECT_WINNING];
    [self performSelector:@selector(endGame) withObject:nil afterDelay:1.5f];
}


@end

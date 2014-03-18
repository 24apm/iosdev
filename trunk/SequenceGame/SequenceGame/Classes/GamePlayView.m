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
    self.startingTime = 0;
    self.gameLayoutView.timeLabel.text = [NSString stringWithFormat:@"0.00"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGameCallback) name:GAME_MANAGER_REFRESH_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lostGame) name:GAME_MANAGER_END_GAME_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(victoryGame) name:GAMEPLAY_VIEW_VICTORY_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftPressedCallback) name:NOTIFICATION_GAME_LAYOUT_VIEW_LEFT_BUTTON_PRESSED object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightPressedCallback) name:NOTIFICATION_GAME_LAYOUT_VIEW_RIGHT_BUTTON_PRESSED object:nil];

    [self renewGame];
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
        self.alpha = 0.0f;
    } completion:^(BOOL complete) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GAMEPLAY_VIEW_DISMISSED_NOTIFICATION object:self];
    }];
}

- (void)renewGame{
    self.userInteractionEnabled = YES;
    [[GameManager instance] generatelevelForTime];
    [self refreshGame];
}

- (void)refreshGameCallback {
    [self.gameLayoutView animatePopFrontUnit];
    [self refreshGame];
}

- (void)refreshGame {
    NSArray *visibleUnits = [[GameManager instance] currentVisibleQueue];
    [self.gameLayoutView updateUnitViews:visibleUnits];
}

- (void)leftPressedCallback {
    // tell manager to dosomething with action
    if (self.timer == nil) {
        [self startTime];
    }
    [[GameManager instance] sequenceCaculation:UserInputDefend];
}


- (void)rightPressedCallback {
    if (self.timer == nil) {
       [self startTime];
    }
    [[GameManager instance] sequenceCaculation:UserInputAttack];
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

- (void)lostGame {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.userInteractionEnabled = NO;
    [self.timer invalidate]; self.timer = nil;
//    [[SoundManager instance] play:SOUND_EFFECT_BOING];
//    [self animateMonsterScaledIn:[self.imagePlaceHolder objectAtIndex:0]];
    [self.gameLayoutView shakeScreen];
    [self.gameLayoutView showMessageViewWithImage:@"rip.png"];
    [self performSelector:@selector(endGame) withObject:nil afterDelay:2.0f];
}

- (void)victoryGame {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.userInteractionEnabled = NO;
    [self.timer invalidate]; self.timer = nil;
    self.finalTime = CACurrentMediaTime() - self.startingTime;
    self.gameLayoutView.timeLabel.text = [NSString stringWithFormat:@"%.3F", self.finalTime];
    [[UserData instance] addNewScoreLocalLeaderBoard:self.finalTime mode:[GameManager instance].gameMode];
    [self.gameLayoutView showMessageView:@"VICTORY!"];
    [[SoundManager instance] play:SOUND_EFFECT_WINNING];
    [self performSelector:@selector(endGame) withObject:nil afterDelay:2.0f];
}

@end

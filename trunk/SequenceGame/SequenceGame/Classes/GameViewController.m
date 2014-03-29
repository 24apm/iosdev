//
//  ViewController.m
//  NumberGame
//
//  Created by MacCoder on 2/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameViewController.h"
#import "GameConstants.h"
#import "Utils.h"
#import "UIView+ViewUtil.h"
#import "AnimUtil.h"
#import "ResultView.h"
#import "MainView.h"
#import "SoundEffect.h"
#import "SoundManager.h"
#import "GamePlayView.h"
#import "GameCenterHelper.h"
#import "UserData.h"
#import "LocalLeaderBoardView.h"
#import "GamePlayDistanceView.h"
#import "GameManager.h"
#import "CustomizationView.h"

@interface GameViewController ()

@property (strong, nonatomic) ResultView *resultView;
@property (strong, nonatomic) MainView *mainView;
@property (strong, nonatomic) GamePlayView *timeAttackMode;
@property (strong, nonatomic) GamePlayDistanceView *distanceAttackMode;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) LocalLeaderBoardView *localLeaderBoardView;
@property (strong, nonatomic) CustomizationView *customizationView;

@end

@implementation GameViewController

- (void)initialize {
    self.currentGameState = -1;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainViewCallback) name:MAIN_VIEW_DISMISSED_NOTIFICATION object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeaderboard) name:SHOW_LEADERBOARD_NOTIFICATION object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAchievements) name: SHOW_ACHIEVEMENT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultViewCallback) name:RESULT_VIEW_DISMISSED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAnswerCallback) name:RESULT_VIEW_SHOW_ANSWER_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAchievementEarned:) name:SHOW_ACHIEVETMENT_EARNED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameplayViewCallback) name:GAMEPLAY_VIEW_DISMISSED_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customizeViewCallback) name:CUSTOMIZE_VIEW_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retryCallback) name:RETRY_BUTTON_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topCallback) name:TOP_BUTTON_NOTIFICATION object:nil];
    
    self.mainView = [[MainView alloc] init];
    [self.containerView addSubview:self.mainView];
    self.mainView.hidden = YES;
    self.mainView.size = self.containerView.size;
    [UserData instance].tutorialModeEnabled = NO;
    
    self.customizationView = [[CustomizationView alloc] init];
    [self.containerView addSubview:self.customizationView ];
    self.customizationView.hidden = YES;
    self.customizationView.size = self.containerView.size;
    
    self.timeAttackMode = [[GamePlayView alloc] init];
    [self.containerView addSubview:self.timeAttackMode ];
    self.timeAttackMode.hidden = YES;
    self.timeAttackMode.size = self.containerView.size;
    
    self.distanceAttackMode = [[GamePlayDistanceView alloc] init];
    [self.containerView addSubview:self.distanceAttackMode ];
    self.distanceAttackMode.hidden = YES;
    self.distanceAttackMode.size = self.containerView.size;
    
    self.resultView = [[ResultView alloc] init];
    [self.containerView addSubview:self.resultView];
    self.resultView.hidden = YES;
    self.resultView.size = self.containerView.size;

    self.localLeaderBoardView = [[LocalLeaderBoardView alloc] init];
    [self.containerView addSubview:self.localLeaderBoardView];
    self.localLeaderBoardView.hidden = YES;
    self.localLeaderBoardView.size = self.containerView.size;
    
    [self preloadSounds];
    [self updateGameState:GameStateMainMode];
}

- (void)preloadSounds {
    [[SoundManager instance] prepare:SOUND_EFFECT_TICKING count:1];
    [[SoundManager instance] prepare:SOUND_EFFECT_WINNING count:2];
    [[SoundManager instance] prepare:SOUND_EFFECT_BOING count:5];
    [[SoundManager instance] prepare:SOUND_EFFECT_POP count:5];
    [[SoundManager instance] prepare:SOUND_EFFECT_BLING count:5];
    [[SoundManager instance] prepare:SOUND_EFFECT_SHARP_PUNCH count:3];
}

- (void)mainViewCallback {
    [self updateGameState:GameStateGameMode];
}

- (void)showLeaderboard {
    [[GameCenterHelper instance] showLeaderboard:self];
}

- (void)showAchievements {
    [[GameCenterHelper instance] showAchievements:self];
}

- (void)numberGameViewCallback {
    [self updateGameState:GameStateResultMode];
}

- (void)resultViewCallback {
    [self updateGameState:GameStateMainMode];
}

- (void)showAnswerCallback {
    [self updateGameState:GameStateShowAnswerMode];
}

- (void)numberGameViewReturnLobbyCallback {
    [self updateGameState:GameStateMainMode];
}

- (void)showAchievementCallBack {
    [self updateGameState:GameStateShowAchievementMode];
}

- (void)gameplayViewCallback {
    [self updateGameState:GameStateLocalLeaderBoardMode];
}

- (void)retryCallback {
    [self updateGameState:GameStateGameMode];
}

- (void)topCallback {
    [self updateGameState:GameStateMainMode];
}

- (void)customizeViewCallback {
    [self updateGameState:GameStateCustomizeMode];
}

- (void)showAchievementEarned: (NSNotification *)notification {
    self.resultView.imgView.image = [UIImage imageNamed:notification.object];
    self.resultView.hidden = NO;
    [self.resultView show];
}

- (void)refresh {
    self.containerView.hidden = NO;
    self.containerView.userInteractionEnabled = YES;
    self.mainView.hidden = YES;
    self.timeAttackMode.hidden = YES;
    self.localLeaderBoardView.hidden = YES;
    self.distanceAttackMode.hidden = YES;
    self.customizationView.hidden = YES;
    
    switch (self.currentGameState) {
        case GameStateMainMode:
            self.mainView.hidden = NO;
            [self.mainView show];
            break;
        case GameStateTutorialMode:
            self.containerView.userInteractionEnabled = NO;
            break;
        case GameStateGameMode:
            if ([[GameManager instance].gameMode isEqualToString:GAME_MODE_TIME]) {
                [self.timeAttackMode show];
                self.timeAttackMode.hidden = NO;
            } else if([[GameManager instance].gameMode isEqualToString:GAME_MODE_DISTANCE]){
                [self.distanceAttackMode show];
                self.distanceAttackMode.hidden = NO;
            }
            break;
        case GameStateLocalLeaderBoardMode:
            self.localLeaderBoardView.hidden = NO;
            [self.localLeaderBoardView show];
            break;
        case GameStateCustomizeMode:
            self.customizationView.hidden = NO;
            [self.customizationView show];
            break;
        default:
            break;
    }
}

- (void)updateGameState:(GameState)gameState {
    if (self.currentGameState != gameState) {
        self.currentGameState = gameState;
        [self refresh];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initialize];
    [self.mainView show];
    
    if (!DEBUG_MODE) {
        [GameCenterHelper instance].currentLeaderBoard = kLeaderboardBestTimeID;
        [[GameCenterHelper instance] loginToGameCenter];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

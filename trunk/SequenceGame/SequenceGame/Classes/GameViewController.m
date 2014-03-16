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
#import "PromoBannerView.h"
#import "PromoManager.h"
#import "LocalLeaderBoardView.h"

@interface GameViewController ()

@property (strong, nonatomic) ResultView *resultView;
@property (strong, nonatomic) MainView *mainView;
@property (strong, nonatomic) GamePlayView *numberGameView;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) PromoBannerView *promoBannerView;
@property (strong, nonatomic) LocalLeaderBoardView *localLeaderBoardView;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retryCallback) name:RETRY_BUTTON_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topCallback) name:TOP_BUTTON_NOTIFICATION object:nil];
    
    self.mainView = [[MainView alloc] init];
    [self.containerView addSubview:self.mainView];
    self.mainView.hidden = YES;
    self.mainView.size = self.containerView.size;
    [UserData instance].tutorialModeEnabled = NO;
    
    self.numberGameView = [[GamePlayView alloc] init];
    [self.containerView addSubview:self.numberGameView ];
    self.numberGameView.hidden = YES;
    self.numberGameView.size = self.containerView.size;
    
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

- (void)showAchievementEarned: (NSNotification *)notification {
    self.resultView.imgView.image = [UIImage imageNamed:notification.object];
    self.resultView.hidden = NO;
    [self.resultView show];
}

- (void)refresh {
    self.containerView.hidden = NO;
    self.containerView.userInteractionEnabled = YES;
    self.mainView.hidden = YES;
    self.numberGameView.hidden = YES;
    self.localLeaderBoardView.hidden = YES;
    
    switch (self.currentGameState) {
        case GameStateMainMode:
            self.mainView.hidden = NO;
            [self.mainView show];
            break;
        case GameStateTutorialMode:
            self.containerView.userInteractionEnabled = NO;
            break;
        case GameStateGameMode:
            self.numberGameView.hidden = NO;
            [self.numberGameView show];
            break;
        case GameStateShowAnswerMode:
            self.numberGameView.hidden = NO;
            [self.numberGameView show];
            break;
        case GameStatePauseMode:
            self.numberGameView.hidden = NO;
            break;
        case GameStateResumeMode:
            self.numberGameView.hidden = NO;
            break;
        case GameStateLocalLeaderBoardMode:
            self.localLeaderBoardView.hidden = NO;
            [self.localLeaderBoardView show];
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
    
    [self createAdBannerView];
    [self.view addSubview:self.adBannerView];
    
    if (!DEBUG_MODE) {
        [GameCenterHelper instance].currentLeaderBoard = kLeaderboardID;
        [[GameCenterHelper instance] loginToGameCenter];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ADs

- (void) createAdBannerView {
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
        self.adBannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    } else {
        self.adBannerView = [[ADBannerView alloc] init];
    }
    self.adBannerView.y = self.view.height - self.adBannerView.height;
    self.adBannerView.delegate = self;
    
    // custom
    self.promoBannerView = [[PromoBannerView alloc] init];
    [self.containerView addSubview:self.promoBannerView];
    self.promoBannerView.frame = self.adBannerView.frame;
    self.promoBannerView.y = self.view.height - self.promoBannerView.height;
    self.promoBannerView.hidden = YES;
}

- (void)layoutAnimated:(BOOL)animated {
    float bannerYOffset;
    if (self.adBannerView.bannerLoaded) {
        self.promoBannerView.hidden = YES;
        bannerYOffset = self.view.height - self.adBannerView.height;
     //   bannerYOffset = self.view.height;
    } else {
        [self.promoBannerView setupWithPromoGameData:[[PromoManager instance] nextPromo]];
        self.promoBannerView.hidden = NO;
      //  self.promoBannerView.hidden = YES;
        bannerYOffset = self.view.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        self.adBannerView.y = bannerYOffset;
    }];
}

#pragma mark - ADBannerViewDelegate

- (void)viewDidLayoutSubviews {
    [self layoutAnimated:[UIView areAnimationsEnabled]];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self layoutAnimated:YES];
}
/*
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    //tap on banner
    [self updateGameState:GameStatePauseMode];
    return  YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    [self updateGameState:GameStateResumeMode];
}
*/

@end

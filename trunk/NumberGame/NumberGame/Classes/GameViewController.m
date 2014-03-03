//
//  ViewController.m
//  NumberGame
//
//  Created by MacCoder on 2/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameViewController.h"
#import "GameConstants.h"
#import "PipeView.h"
#import "Utils.h"
#import "UIView+ViewUtil.h"
#import "AnimUtil.h"
#import "ResultView.h"
#import "MainView.h"
#import "TutorialView.h"
#import "SoundEffect.h"
#import "SoundManager.h"
#import "MenuView.h"
#import "NumberManager.h"
#import "NumberGameView.h"
#import "GameCenterHelper.h"
#import "UserData.h"
#import "PromoBannerView.h"
#import "PromoManager.h"

#define SOUND_EFFECT_BANG @"bang"
#define SOUND_EFFECT_BOING @"boing"

@interface GameViewController ()

@property (strong, nonatomic) NSMutableArray *worldObstacles;
@property (strong, nonatomic) NSMutableArray *scorableObjects;

@property (nonatomic) BOOL isGameOver;
@property (nonatomic) BOOL isRunning;

@property (nonatomic) int score;
@property (nonatomic) PipeView *lastGeneratedPipe;

@property (nonatomic) int maxScore;
@property (nonatomic) BOOL firstTapped;
@property (strong, nonatomic) TutorialView *tutorialView;
@property (strong, nonatomic) ResultView *resultView;
@property (strong, nonatomic) MainView *mainView;
@property (strong, nonatomic) MenuView *menuView;
@property (strong, nonatomic) NumberGameView *numberGameView;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) PromoBannerView *promoBannerView;

@end

@implementation GameViewController

- (void)initialize {
    self.currentGameState = -1;
    self.worldObstacles = [NSMutableArray array];
    self.scorableObjects = [NSMutableArray array];
    self.score = 0;
    self.maxScore = 0;
    self.isRunning = YES;
    self.lastGeneratedPipe = nil;
    _isGameOver = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultViewCallback) name:RESULT_VIEW_DISMISSED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainViewCallback) name:MAIN_VIEW_DISMISSED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuViewCallback) name:MENU_VIEW_DISMISSED_NOTIFICATION object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultViewCallback) name:MENU_VIEW_GO_TO_MAIN_MENU_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeaderboard) name:SHOW_LEADERBOARD_NOTIFICATION object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberGameViewCallback) name: NUMBER_GAME_CALLBACK_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAchievements) name: SHOW_ACHIEVEMENT_NOTIFICATION object:nil];
    
    [self createObstacle];
    
    self.tutorialView = [[TutorialView alloc] init];
    [self.containerView addSubview:self.tutorialView];
    self.tutorialView.hidden = YES;
    self.tutorialView.size = self.containerView.size;
    
    
    self.mainView = [[MainView alloc] init];
    [self.containerView addSubview:self.mainView];
    self.mainView.hidden = YES;
    self.mainView.size = self.containerView.size;
    
    self.numberGameView = [[NumberGameView alloc] init];
    [self.containerView addSubview:self.numberGameView ];
    self.numberGameView.hidden = YES;
    self.numberGameView.size = self.containerView.size;
    
    self.resultView = [[ResultView alloc] init];
    [self.containerView addSubview:self.resultView];
    self.resultView.hidden = YES;
    self.resultView.size = self.containerView.size;
    self.resultView.vc = self;
    self.resultView.sharedImage = self.ladyBugView.imageView.image;
    
    
    self.menuView = [[MenuView alloc] init];
    [self.containerView addSubview:self.menuView];
    self.menuView.hidden = YES;
    self.menuView.size = self.containerView.size;
    

    
    
    if (BLACK_AND_WHITE_MODE) {
        [self blackAndWhite];
    }
    [self preloadSounds];
    [self updateGameState:GameStateMainMode];
}

- (void)preloadSounds {
    [[SoundManager instance] prepare:SOUND_EFFECT_BANG count:2];
    [[SoundManager instance] prepare:SOUND_EFFECT_BOING count:5];
}

- (void)gameViewsHidden:(BOOL)hidden {
    self.ladyBugView.hidden = hidden;
    self.obstacleLayer.hidden = hidden;
    self.scoreLabel.hidden = hidden;
    self.menuButton.hidden = hidden;
    self.maxScoreLabel.hidden = hidden;
    self.highestScoreText.hidden = hidden;
}


- (IBAction)menuPressed:(id)sender {
    [self updateGameState:GameStateMenuMode];
}

- (void)resultViewCallback {
    [self updateGameState:GameStateMainMode];
}

- (void)mainViewCallback {
    [self updateGameState:GameStateGameMode];
}

- (void)menuViewCallback {
    if (self.isGameOver) {
        [self updateGameState:GameStateResultMode];
    } else {
        [self updateGameState:GameStateResumeMode];
    }
}

- (void)numberGameViewCallback {
    [self updateGameState:GameStateResultMode];
}

- (void)showLeaderboard {
    [[GameCenterHelper instance] showLeaderboard:self];
}

-(void)showAchievements {
    [[GameCenterHelper instance] showAchievements:self];
}

- (void)refresh {
    [self gameViewsHidden:YES];
    self.containerView.hidden = NO;
    self.containerView.userInteractionEnabled = YES;
    self.mainView.hidden = YES;
    self.tutorialView.hidden = YES;
    self.resultView.hidden = YES;
    self.menuView.hidden = YES;
    self.menuButton.hidden = YES;
    self.numberGameView.hidden = YES;

    switch (self.currentGameState) {
        case GameStateMainMode:
            self.isRunning = YES;
            self.mainView.hidden = NO;
            [self.mainView show];
            break;
        case GameStateTutorialMode:
            [self gameViewsHidden:NO];
            self.menuButton.hidden = YES;
            self.containerView.userInteractionEnabled = NO;
            self.tutorialView.hidden = NO;
            [self restartGame];
            self.ladyBugView.currentState = LadyBugViewStateTutorialMode;
            [self.ladyBugView refresh];
            break;
        case GameStateGameMode:
            self.numberGameView.hidden = NO;
            [self.numberGameView show];
            self.containerView.hidden = NO;
            break;
        case GameStateMenuMode:
            self.isRunning = NO;
            [self gameViewsHidden:NO];
            self.menuView.hidden = NO;
            [self.menuView show];
            break;
        case GameStateResumeMode:
            [self gameViewsHidden:NO];
            self.containerView.userInteractionEnabled = NO;
            self.isRunning = YES;
            break;
        case GameStateResultMode:
            self.resultView.hidden = NO;
//            self.resultView.sharedText = [NSString stringWithFormat:@"High Score: %d!", self.maxScore];
            [[GameCenterHelper instance] checkAchievements];
            [self.resultView show];
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

- (IBAction)tapButtonPressed:(id)sender {
    if (self.isGameOver == YES) return;
    
    self.firstTapped = YES;
    [self.ladyBugView resume];
    self.ladyBugView.properties.speed = CGPointMake(0.f, TAP_SPEED_INCREASE * IPAD_SCALE);
    
    self.ladyBugView.properties.acceleration = CGPointMake(self.ladyBugView.properties.acceleration.x, self.ladyBugView.properties.acceleration.y + TAP_ACCELATION_INCREASE);
    
    self.ladyBugView.properties.rotation = 0.f;
    
    if (self.ladyBugView.frame.origin.y < 0.f) {
        self.ladyBugView.properties.speed = CGPointMake(0.f, 0);
        
        self.ladyBugView.properties.acceleration = CGPointMake(self.ladyBugView.properties.acceleration.x, 0);
    }
}

- (void)createObstacle {
    PipeView *pipeView;
    for (int i = 0; i < PIPES_COUNT; i++) {
        pipeView = [[PipeView alloc] init];
        
        [self.worldObstacles addObject:pipeView];
        [self.obstacleLayer addSubview:pipeView];
    }
    [self resetPipes];
}

- (void)blackAndWhite {
    self.backgroundView.backgroundImage.image = nil;
    self.backgroundView.backgroundImage.backgroundColor = [UIColor blackColor];
}

- (void)resetPipe:(PipeView *)pipeView {
    float randomY = [Utils randBetweenMin:self.view.frame.size.height * 0.3f max:self.view.frame.size.height * 0.7f];
    [pipeView setupGapDistance:self.ladyBugView.frame.size.height * OBSTACLE_GAP_BY_CHARACTER_MULTIPLIER gapCenterY:randomY];
    [self.scorableObjects addObject:pipeView];
    if (self.lastGeneratedPipe) {
        pipeView.x = self.lastGeneratedPipe.x + self.view.width * OBSTACLE_GAP_BY_SCREEN_WIDTH_PERCENTAGE;
    } else {
        pipeView.x = self.view.width * 1.5f;
    }
    self.lastGeneratedPipe = pipeView;
}

- (void)resetPipes {
    for (PipeView *pipeView in self.worldObstacles) {
        // off map
        [self resetPipe:pipeView];
    }
}

- (void)restartGame {
    self.isRunning = YES;
    self.isGameOver = NO;
    [self.scorableObjects removeAllObjects];
    [self.ladyBugView resume];
    self.ladyBugView.center = CGPointMake(self.ladyBugView.center.x, self.view.center.y) ;
    self.ladyBugView.startingPoint = self.ladyBugView.center;
    self.score = 0;
    self.firstTapped = NO;
    self.lastGeneratedPipe = nil;
    [self resetPipes];
}

- (void)setFirstTapped:(BOOL)firstTapped {
    _firstTapped = firstTapped;
    if (firstTapped) {
        [self updateGameState:GameStateGameMode];
    }
}

- (IBAction)rematchPressed:(id)sender {
    [self restartGame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initialize];
    [self.mainView show];
    
    [self createAdBannerView];
    [self.view addSubview:self.adBannerView];
    [GameCenterHelper instance].currentLeaderBoard = kLeaderboardID;
    [[GameCenterHelper instance] loginToGameCenter];
  
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
    self.adBannerView.y = self.view.height;
    self.adBannerView.delegate = self;
    
    // custom
    self.promoBannerView = [[PromoBannerView alloc] init];
    [self.containerView addSubview:self.promoBannerView];
    self.promoBannerView.frame = self.adBannerView.frame;
    self.promoBannerView.y = self.view.height - self.promoBannerView.height;
    self.promoBannerView.hidden = YES;
}

- (void)layoutAnimated:(BOOL)animated {
    float bannerYOffset = self.view.height;
    if (self.adBannerView.bannerLoaded) {
        bannerYOffset = self.view.height - self.adBannerView.height;
        self.promoBannerView.hidden = YES;
    } else {
        bannerYOffset = self.view.height;
        [self.promoBannerView setupWithPromoGameData:[[PromoManager instance] nextPromo]];
        self.promoBannerView.hidden = NO;
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


@end

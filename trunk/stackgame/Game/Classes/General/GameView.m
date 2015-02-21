//
//  GameView.m
//  Vocabulary
//
//  Created by MacCoder on 10/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameView.h"
#import "BoardView.h"
#import "VocabularyTableDialogView.h"
#import "VocabularyManager.h"
#import "LevelData.h"
#import "VocabularyObject.h"
#import "MessageDialogView.h"
#import "UserData.h"
#import "GameConstants.h"
#import "CAEmitterHelperLayer.h"
#import "CompletedLevelDialogView.h"
#import "CoinIAPHelper.h"
#import "UpgradeView.h"
#import "THLabel.h"
#import "PromoDialogView.h"
#import "GameCenterHelper.h"
#import "SoundManager.h"
#import "GameLoopTimer.h"
#import "ProgressBarComponent.h"
#import "ConfigManager.h"
#import "TrackUtils.h"
#import "ButtonBase.h"
#import "GameCenterManager.h"
#import "UserChoice.h"

#define CURRENT_TIME [[NSDate date] timeIntervalSince1970]
#define TIME_FOR_ONE_RETRY 720.0
#define FADE_DURATION 1.8f


@interface GameView()
@property (strong, nonatomic) IBOutlet UIButton *unlockBoardBackground;
@property (strong, nonatomic) IBOutlet UIView *gamecenterBlocker;

@property (strong, nonatomic) IBOutlet UILabel *nextLiveTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *keyImageView;

@property (strong, nonatomic) IBOutlet UIView *lockedBoardView;
@property (strong, nonatomic) IBOutlet UILabel *liveStockLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UILabel *nextLevelLabel;
@property (strong, nonatomic) BoardView *boardView;
@property (strong, nonatomic) IBOutlet UIView *boardViewContainer;
@property (strong, nonatomic) LevelData *levelData;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *wordButton;
@property (nonatomic) BOOL newSectionUnlocked;
@property (strong, nonatomic) IBOutlet ButtonBase *unlockButon;
@property (nonatomic) BOOL unlockingBoardBool;
@property (strong, nonatomic) IBOutlet UIButton *answerButton;
@property (strong, nonatomic) IBOutlet UIButton *buyKeyButton;
@property (strong, nonatomic) IBOutlet UIImageView *lockedBoardImage;

@property (strong, nonatomic) IBOutlet UIView *emitterLayer;
@property (strong, nonatomic) IBOutlet UIImageView *foundNewWordGlowView;
@property (strong, nonatomic) IBOutlet UIImageView *wordBook;
@property (nonatomic) NSInteger numOfGame;
@property (nonatomic) BOOL gameEnded;
@property (nonatomic) double startTime;
@property (nonatomic) double nextDropTime;
@property (nonatomic) double shiftBlockTime;
@property (strong, nonatomic) IBOutlet UserChoice *userChoice1;
@property (strong, nonatomic) IBOutlet UserChoice *userChoice2;
@property (strong, nonatomic) IBOutlet UserChoice *userChoice3;


@property (nonatomic) NSInteger currentPrevIndex;
@end

@implementation GameView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.boardView = [[BoardView alloc] initWithFrame:CGRectMake(0, 0, self.boardViewContainer.size.width, self.boardViewContainer.size.height)];
        [self.boardViewContainer addSubview:self.boardView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBubble) name:VocabularyTableDialogViewDimissed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateAddingKeys) name:ADD_KEY_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyMoreCoin) name:BUY_COIN_VIEW_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawStep) name:DRAW_STEP_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChoicePressed:) name:USER_CHOICE_PRESSED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCompleteLevel) name:GAME_END object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openBookEndGame) name:OPEN_BOOK_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(generateNewLevelEndGame) name:START_NEW_GAME_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockedAnswerButton) name:UNLOCK_ANSWER_NOTIFICATION object:nil];
        self.newSectionUnlocked = NO;
        [self refillRetryAtStart];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.spinner];
        self.spinner.hidesWhenStopped = YES;
        self.spinner.center = self.center;
        self.numOfGame = 0;
        self.liveStockLabel.text = [NSString stringWithFormat:@"x%.f", 0.0];
        self.nextLiveTimeLabel.text = [NSString stringWithFormat:@"%d:0%d", 0, 0];
        if ([[UserData instance] unseenWordCount] > 0) {
            [self hasUnseenWords:YES];
        } else {
            [self hasUnseenWords:NO];
        }
        self.unlockingBoardBool = NO;
        [self unlockBoardSetTo:YES];
        [self startFallingEffect];
        [self initUnlockingBoardAnimation];
        //        [self shuffleChoiceButton];
        [self generateNewLevel];
        self.nextDropTime = CURRENT_TIME;
        self.shiftBlockTime = CURRENT_TIME;
    }
    return self;
}

- (void)startFallingEffect {
    CAEmitterHelperLayer *cell = [CAEmitterHelperLayer emitter:@"particleEffectFalling.json" onView:self.emitterLayer];
    CGPoint point = CGPointMake(self.emitterLayer.width/2, 0);
    [cell setStartPoint:point];
    [cell refreshEmitter];
    
}

- (void)refillRetryAtStart {
    double gapTime = CURRENT_TIME - [UserData instance].retryTime;
    NSInteger numberOfRetrySaved = gapTime/TIME_FOR_ONE_RETRY;
    for (NSInteger i = 0; i < numberOfRetrySaved; i++) {
        [[UserData instance] refillRetryByOne];
        double newRefillTime = [UserData instance].retryTime + TIME_FOR_ONE_RETRY;
        [[UserData instance] retryRefillStartAt:newRefillTime];
        if ([UserData instance].retry >= [UserData instance].retryCapacity) {
            [[UserData instance] retryRefillStartAt: CURRENT_TIME];
            break;
        }
    }
}

- (void)drawStep {
    
    if (CURRENT_TIME - self.shiftBlockTime > 0.5f) {
        [self.boardView shiftBlocksDown];
        self.shiftBlockTime = CURRENT_TIME;
    }
    
    if (CURRENT_TIME - self.nextDropTime > 1.5f) {
        [self.boardView placeBlockLine];
        self.nextDropTime = CURRENT_TIME;
    }
    
    if ([UserData instance].retry < [UserData instance].retryCapacity) {
        double gapTime = CURRENT_TIME - [UserData instance].retryTime;
        if (gapTime >= TIME_FOR_ONE_RETRY) {
            [[UserData instance] retryRefillStartAt:CURRENT_TIME];
            [[UserData instance] refillRetryByOne];
        }
    }
    [self fillLiveTime];
}


-(void)lockedAnswerButton {
    self.answerButton.userInteractionEnabled = NO;
}

- (void)fillLiveTime {
    self.nextLiveTimeLabel.hidden = YES;
    
    double currentOwnedRetry = [UserData instance].retry;
    NSInteger nextRetryTime = 0;
    if (currentOwnedRetry < [UserData instance].retryCapacity) {
        nextRetryTime = ([UserData instance].retryTime + TIME_FOR_ONE_RETRY) - CURRENT_TIME;
        if (nextRetryTime < 0) {
            nextRetryTime = 0;
        } else {
            self.nextLiveTimeLabel.hidden = NO;
            NSInteger min = nextRetryTime / 60;
            NSInteger sec = nextRetryTime % 60;
            self.nextLiveTimeLabel.text = [NSString stringWithFormat:@"Next in: %ld:%0.2ld", (long)min, (long)sec];
        }
    }
    self.liveStockLabel.text = [NSString stringWithFormat:@"x%.f", currentOwnedRetry];
    
    if (currentOwnedRetry >= [UserData instance].retryCapacity) {
        self.liveStockLabel.textColor = [UIColor greenColor];
    } else {
        self.liveStockLabel.textColor = [UIColor whiteColor];
    }
}

- (void)isWaitingState:(BOOL)state {
    self.unlockButon.hidden = !state;
    [self animateLockedBoardToOpen:!state];
}

- (void)openBookEndGame {
    [self unlockBoardSetTo:NO];
    [[[VocabularyTableDialogView alloc] init] show];
}

- (void)generateNewLevelEndGame {
    if ([[UserData instance] hasRetry]) {
        [[UserData instance] decrementRetry];
        [self generateNewLevel];
    } else {
        [self isWaitingState:YES];
        [[[UpgradeView alloc] initWithBlock:^{
        }] showForKey];
    }
}

- (void)buyMoreCoin {
    [[CoinIAPHelper sharedInstance] showCoinMenu];
}

- (void)updateBubbleCount:(NSInteger)count {
    if (count > 0) {
        [self hasUnseenWords:YES];
    } else {
        [self hasUnseenWords:NO];
    }
}

- (void)hasUnseenWords:(BOOL)state {
    if (state) {
        self.foundNewWordGlowView.hidden = NO;
        self.wordBook.highlighted = YES;
    } else {
        self.wordBook.highlighted = NO;
        self.foundNewWordGlowView.hidden = YES;
    }
}

- (void)hasUnseenWordsNSNumber:(NSNumber *)state {
    [self hasUnseenWords:[state boolValue]];
}

- (void)setup {
    //[self generateNewLevel];
}

- (IBAction)wordPressed:(id)sender {
    [[[VocabularyTableDialogView alloc] init] show];
}

- (void)decrementRetry {
    if ([UserData instance].retry >= [UserData instance].retryCapacity) {
        [UserData instance].retryTime = CURRENT_TIME;
    }
    [[UserData instance] decrementRetry];
}

- (IBAction)resetPressed:(id)sender {
    [[GameCenterHelper instance] showLeaderboard:[Utils rootViewController]];
    //[self animateLockedBoardToOpen:NO];
    //[self userInterfaceInWaiting:YES];
    // [self showCompleteLevel];
    //[self decrementRetry];
    // [self performSelector:@selector(generateNewLevel) withObject:nil afterDelay:0.0];
    //self.answerButton.userInteractionEnabled = YES;
}

- (IBAction)answerPressed:(id)sender {
    [[[UpgradeView alloc] init] showForAnswer];
}
- (IBAction)unlockedButtonPressed:(UIButton *)sender {
    if (self.unlockingBoardBool == NO) {
        if ([UserData instance].retry > 0) {
            self.unlockingBoardBool = YES;
            self.lockedBoardView.userInteractionEnabled = NO;
            [self generateNewLevel];
            [self isWaitingState:NO];
            [self decrementRetry];
        } else {
            [[[UpgradeView alloc] init] showForKey];
        }
    }
}

- (IBAction)lockedBoardPressed:(UIButton *)sender {
    
    [self unlockedButtonPressed:sender];
}

- (void)unlockBoardSetTo:(BOOL)state {
    self.lockedBoardView.hidden = state;
    self.lockedBoardView.userInteractionEnabled = YES;
    self.unlockingBoardBool = NO;
}

- (void)unlockBoardSetToWithNSNumber:(NSNumber *)state {
    [self unlockBoardSetTo:[state boolValue]];
}

- (void)animateLockedBoardToOpen:(BOOL)state {
    if (state == NO) {
        [self unlockBoardSetTo:NO];
    }
    if (state == YES) {
        [self.lockedBoardImage startAnimating];
        [self performSelector:@selector(delayFadingForUnlockAnimation) withObject:nil afterDelay:FADE_DURATION];
        [self performSelector:@selector(unlockBoardSetToWithNSNumber:) withObject:[NSNumber numberWithBool:state] afterDelay:FADE_DURATION + FADE_DURATION + 0.1f];
    } else {
        [self animateFadeInAndOut:self.lockedBoardView forState:state];
        [self performSelector:@selector(unlockBoardSetToWithNSNumber:) withObject:[NSNumber numberWithBool:state] afterDelay:FADE_DURATION + 0.1f];
    }
}

- (void)delayFadingForUnlockAnimation {
    [self animateFadeInAndOut:self.lockedBoardView forState:YES];
}

-(void)animateFadeInAndOut:(UIView *)view forState:(BOOL)state {
    float startValue = 0.0;
    float endValue = 0.0;
    if (state == NO) {
        endValue = 1.0;
    } else {
        startValue = 1.0;
    }
    CABasicAnimation *fadeInAndOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAndOut.fromValue = [NSNumber numberWithFloat:startValue];
    fadeInAndOut.toValue = [NSNumber numberWithFloat:endValue];
    fadeInAndOut.duration = FADE_DURATION;
    fadeInAndOut.removedOnCompletion = NO;
    fadeInAndOut.fillMode = kCAFillModeBoth;
    [view.layer addAnimation:fadeInAndOut forKey:@"fadeInAndOut"];
    [self performSelector:@selector(removeViewAnimation:) withObject:view afterDelay:fadeInAndOut.duration + 0.2f];
}

- (void)removeViewAnimation:(UIView *)view {
    [view.layer removeAllAnimations];
}

- (void)addKey {
    [[UserData instance] refillRetry];
    self.buyKeyButton.hidden = NO;
    self.lockedBoardView.userInteractionEnabled = YES;
}

- (void)animateAddingKeys {
    [TrackUtils trackAction:@"boughtKey" label:@""];
    self.buyKeyButton.hidden = YES;
    self.lockedBoardView.userInteractionEnabled = NO;
    [self performSelector:@selector(_animateAddingKeys) withObject:nil afterDelay:1.4f];
}

- (void)_animateAddingKeys {
    NSInteger gap = [UserData instance].retryCapacity - [UserData instance].retry;
    double delay = 0;
    
    for (NSInteger i = 0; i < gap; i ++) {
        CAEmitterHelperLayer *cellLayer = [CAEmitterHelperLayer emitter:@"particleEffectKeys.json" onView:self];
        cellLayer.cellImage = [UIImage imageNamed:@"key"];
        float x = [Utils randBetweenMin:0 max:self.width];
        
        CGPoint start = CGPointMake(x, self.height);
        
        CGPoint toPoint = self.keyImageView.center;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:start];
        
        CGFloat rand = arc4random() % (NSInteger)self.width;
        CGPoint c = CGPointMake(rand, rand);
        [path addQuadCurveToPoint:toPoint controlPoint:c];
        
        CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
        position.removedOnCompletion = NO;
        position.fillMode = kCAFillModeBoth;
        position.path = path.CGPath;
        position.duration = cellLayer.lifeSpan;
        [cellLayer addAnimation:position forKey:@"animateIn"];
        delay = position.duration;
    }
    [self performSelector:@selector(animatingExplosionForKey:) withObject:self.liveStockLabel afterDelay:delay - 0.1f];
    [self performSelector:@selector(addKey) withObject:nil afterDelay:delay];
}

- (IBAction)buyKeyButtonPressed:(UIButton *)sender {
    if ([UserData instance].retry <= 0) {
        [[[UpgradeView alloc] init] showForKey];
    }
}

- (void)updateNextLevel
{
    NSInteger prevLevelCap = [[VocabularyManager instance] mixVocabIndexWith:self.currentPrevIndex -1];
    NSInteger currentLevel = [UserData instance].pokedex.count - prevLevelCap;
    NSInteger currentLevelCap = [[VocabularyManager instance] mixVocabIndexWith:self.currentPrevIndex] - prevLevelCap;
    
    if (currentLevel >= currentLevelCap) {
        self.newSectionUnlocked = YES;
        
    }
}

- (void)checkGameCenter {
    if([GameCenterManager isGameCenterAvailable]) {
        self.gamecenterBlocker.hidden = YES;
    } else {
        self.gamecenterBlocker.hidden = NO;
    }
}

- (void)generateNewLevel {
    [self shuffleChoiceButton];
    [self checkGameCenter];
    self.startTime = CURRENT_TIME;
    self.currentPrevIndex = [[VocabularyManager instance] unlockUptoLevel];
    self.levelData = [[VocabularyManager instance] generateLevel:NUM_ROW
                                                             col:NUM_COL];
    [self.boardView setupWithLevel:self.levelData];
    [self updateBubbleCount:[[UserData instance] unseenWordCount]];
    //debug
    //    [self.levelData printAnswers];
}

- (void)wordMatched:(NSNotification *)notification {
    NSMutableDictionary *dictionary = notification.object;
    NSArray *slotViews = [dictionary objectForKey:@"slotsArray"];
    NSString *word = [dictionary objectForKey:@"word"];
    
    // if new word, animate
    if (![[VocabularyManager instance] hasUserUnlockedVocab:word]) {
        [self performSelector:@selector(animateFromTileToMenu:) withObject:slotViews afterDelay:0.6f];
    }
    
    [self.levelData.wordsFoundList addObject:word];
    [[VocabularyManager instance] addWordToUserData:word];
    //[self performSelector:@selector(refreshBubble) withObject:nil afterDelay:0.6f];
    
    // end game
    if ([[VocabularyManager instance] hasCompletedLevel:self.levelData]) {
        [self performSelector:@selector(showCompleteLevel) withObject:nil afterDelay:1.0f];
    }
}

- (void)refreshBubble {
    [self updateBubbleCount:[[UserData instance] unseenWordCount]];
}

- (void)showCompleteLevel {
    if (self.newSectionUnlocked) {
        self.newSectionUnlocked = NO;
        // dialog - new level unlocked
        [[SoundManager instance] play:SOUND_EFFECT_WINNING];
        [[[CompletedLevelDialogView alloc] initForState:GAME_END_NEW] show];
    } else {
        // no dialog, auto refresh
        [[[CompletedLevelDialogView alloc] initForState:GAME_END] show];
        if ([UserData instance].isTutorial) {
            [[GameCenterHelper instance] loginToGameCenterWithAuthentication];
        }
    }
    self.answerButton.userInteractionEnabled = YES;
    self.numOfGame++;
    [self timeGap:CURRENT_TIME - self.startTime];
    [[UserData instance] incrementGamePlayed];
    if (self.numOfGame % 3 == 0) {
        [PromoDialogView show];
    }
}

- (void)timeGap:(double)gap {
    NSString *timeLabel = @"10sec";
    if (gap < 10) {
        timeLabel = @"10sec";
    } else if (gap < 20) {
        timeLabel = @"20sec";
    } else if (gap < 30) {
        timeLabel = @"30sec";
    } else if (gap < 40) {
        timeLabel = @"40sec";
    } else if (gap < 50) {
        timeLabel = @"50sec";
    } else if (gap < 60) {
        timeLabel = @"1min";
    } else if (gap < 90) {
        timeLabel = @"1min30sec";
    } else if (gap < 180) {
        timeLabel = @"3min";
    } else if (gap < 240) {
        timeLabel = @"4min";
    } else if (gap < 300) {
        timeLabel = @"5min";
    } else if (gap < 360) {
        timeLabel = @"6min";
    } else if (gap < 420) {
        timeLabel = @"7min";
    } else if (gap < 480) {
        timeLabel = @"8min";
    } else if (gap < 540) {
        timeLabel = @"9min";
    } else if (gap < 600) {
        timeLabel = @"10min";
    } else if (gap < 900) {
        timeLabel = @"15min";
    } else if (gap < 1200) {
        timeLabel = @"20min";
    } else if (gap < 1800) {
        timeLabel = @"30min";
    } else if (gap < 3600) {
        timeLabel = @"1hr";
    } else {
        timeLabel = @"1hr+";
    }
    //[TrackUtils trackAction:@"timeGamePlayed" label:timeLabel];
}

- (void)animateFromTileToMenu:(NSArray *)slotViews {
    // animation
    for (UIView *slotView in slotViews) {
        [self animatingAnswer:slotView toView:self.wordButton];
    }
}

- (void)animatingAnswer:(UIView *)fromView toView:(UIView *)toView {
    CAEmitterHelperLayer *cellLayer = [CAEmitterHelperLayer emitter:@"particleEffect.json" onView:self];
    cellLayer.lifeSpan *= 2;
    [cellLayer refreshEmitter];
    
    CGPoint start = [fromView.superview convertPoint:fromView.center toView:self];
    
    CGPoint toPoint = [toView.superview convertPoint:toView.center toView:self];
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCGPoint:start]];
    [values addObject:[NSValue valueWithCGPoint:toPoint]];
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
    position.removedOnCompletion = NO;
    position.fillMode = kCAFillModeBoth;
    position.values = values;
    position.duration = cellLayer.lifeSpan;
    [cellLayer addAnimation:position forKey:@"animateIn"];
    if (self.wordBook.highlighted == NO) {
        [self performSelector:@selector(animatingExplosion:) withObject:self.wordBook afterDelay: position.duration +.01f];
    }
}

- (void)animatingExplosion:(UIView *)view {
    CAEmitterHelperLayer *cellLayer = [CAEmitterHelperLayer emitter:@"particleEffectFastBurst.json" onView:self];
    CGPoint point = view.center;
    cellLayer.position = point;
    [self performSelector:@selector(hasUnseenWordsNSNumber:) withObject:[NSNumber numberWithBool:YES] afterDelay: 0.1f];
}

- (void)animatingExplosionForKey:(UIView *)view {
    CAEmitterHelperLayer *cellLayer = [CAEmitterHelperLayer emitter:@"particleEffectSpark.json" onView:self];
    CGPoint point = view.center;
    cellLayer.position = point;
}


- (void)initUnlockingBoardAnimation {
    UIImage* img1 = [UIImage imageNamed:@"cut1.png"];
    UIImage* img2 = [UIImage imageNamed:@"cut2.png"];
    UIImage* img3 = [UIImage imageNamed:@"cut3.png"];
    UIImage* img4 = [UIImage imageNamed:@"cut4.png"];
    UIImage* img5 = [UIImage imageNamed:@"cut5.png"];
    UIImage* img6 = [UIImage imageNamed:@"cut6.png"];
    UIImage* img7 = [UIImage imageNamed:@"cut7.png"];
    UIImage* img8 = [UIImage imageNamed:@"cut8.png"];
    UIImage* img9 = [UIImage imageNamed:@"cut9.png"];
    NSArray *images = [NSArray arrayWithObjects:img1,img2,img3,img4,img5,img6,img7,img8,img9,img9,img9,img9,img9,img9,img9,img9,img9,img9, nil];
    self.lockedBoardImage.animationImages = images;
    self.lockedBoardImage.animationRepeatCount = 1;
    self.lockedBoardImage.animationDuration = FADE_DURATION+FADE_DURATION;
}

//- (IBAction)button1Pressed:(UIButton *)sender {
//    [self buttonPressedNotification:[NSString stringWithFormat:@"%d", self.choice1.tag]];
//}
//- (IBAction)button2Pressed:(UIButton *)sender {
//    [self buttonPressedNotification:[NSString stringWithFormat:@"%d", self.choice2.tag]];
//}
//- (IBAction)button3Pressed:(UIButton *)sender {
//    [self buttonPressedNotification:[NSString stringWithFormat:@"%d", self.choice3.tag]];
//}

- (void)userChoicePressed:(NSNotification *)notification {
    BlockType type = [notification.object integerValue];
    [self.boardView destroyBlocksForType:type];
    
    
    [self shuffleChoiceButton];
}

- (NSMutableArray *)createChoiceArray {
    NSMutableArray *arrayOfChoices = [NSMutableArray array];
    [arrayOfChoices addObject:[NSNumber numberWithInteger:BlockType_Apple]];
    [arrayOfChoices addObject:[NSNumber numberWithInteger:BlockType_Watermelon]];
    [arrayOfChoices addObject:[NSNumber numberWithInteger:BlockType_Mango]];
    [arrayOfChoices addObject:[NSNumber numberWithInteger:BlockType_Strawberry]];
    [arrayOfChoices addObject:[NSNumber numberWithInteger:BlockType_Pear]];
    [arrayOfChoices addObject:[NSNumber numberWithInteger:BlockType_Grape]];
    [arrayOfChoices addObject:[NSNumber numberWithInteger:BlockType_Banana]];
    [arrayOfChoices addObject:[NSNumber numberWithInteger:BlockType_Cherry]];
    [arrayOfChoices addObject:[NSNumber numberWithInteger:BlockType_Lemon]];
    return  arrayOfChoices;
}

- (void)shuffleChoiceButton {
    
    NSMutableArray *arrayOfChoices = [self createChoiceArray];
    NSInteger index = [Utils randBetweenMinInt:0 max:arrayOfChoices.count -1];
    [self.userChoice1 setChoiceID:[[arrayOfChoices objectAtIndex:index] integerValue]];
    [arrayOfChoices removeObjectAtIndex:index];
    index = [Utils randBetweenMinInt:0 max:arrayOfChoices.count -1];
    
    [self.userChoice2 setChoiceID:[[arrayOfChoices objectAtIndex:index] integerValue]];
    [arrayOfChoices removeObjectAtIndex:index];
    index = [Utils randBetweenMinInt:0 max:arrayOfChoices.count -1];
    
    [self.userChoice3 setChoiceID:[[arrayOfChoices objectAtIndex:index] integerValue]];
}

@end
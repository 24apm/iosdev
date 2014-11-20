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

#define CURRENT_TIME [[NSDate date] timeIntervalSince1970]
#define TIME_FOR_ONE_RETRY 720.0
#define FADE_DURATION 1.8f

@interface GameView()

@property (strong, nonatomic) IBOutlet UILabel *nextLiveTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *keyImageView;

@property (strong, nonatomic) IBOutlet UIView *lockedBoardView;
@property (strong, nonatomic) IBOutlet UILabel *liveStockLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UILabel *nextLevelLabel;
@property (strong, nonatomic) BoardView *boardView;
@property (strong, nonatomic) IBOutlet UIView *boardViewContainer;
@property (strong, nonatomic) IBOutletCollection(THLabel) NSArray *words;
@property (strong, nonatomic) IBOutlet UILabel *definitionLabel;
@property (strong, nonatomic) LevelData *levelData;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *wordButton;
@property (nonatomic) BOOL newSectionUnlocked;
@property (nonatomic) BOOL unlockingBoardBool;
@property (strong, nonatomic) IBOutlet UIButton *answerButton;
@property (strong, nonatomic) IBOutlet UIButton *buyKeyButton;

@property (strong, nonatomic) IBOutlet UIImageView *foundNewWordGlowView;
@property (strong, nonatomic) IBOutlet UIImageView *wordBook;
@property (nonatomic) NSInteger numOfGame;
@property (nonatomic) BOOL gameEnded;
@property (strong, nonatomic) IBOutlet UIView *animationView;


@property (nonatomic) NSInteger currentPrevIndex;
@end

@implementation GameView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.boardView = [[BoardView alloc] initWithFrame:CGRectMake(0, 0, self.boardViewContainer.size.width, self.boardViewContainer.size.height)];
        [self.boardViewContainer addSubview:self.boardView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wordMatched:) name:NOTIFICATION_WORD_MATCHED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBubble) name:VocabularyTableDialogViewDimissed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockAnswer) name:UNLOCK_ANSWER_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateAddingKeys) name:ADD_KEY_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyMoreCoin) name:BUY_COIN_VIEW_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawStep) name:DRAW_STEP_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openBookEndGame) name:OPEN_BOOK_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(generateNewLevelEndGame) name:START_NEW_GAME_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockedAnswerButton) name:UNLOCK_ANSWER_NOTIFICATION object:nil];
        self.newSectionUnlocked = NO;
        [self refillRetryAtStart];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.spinner];
        self.spinner.hidesWhenStopped = YES;
        self.spinner.center = self.definitionLabel.center;
        self.numOfGame = 0;
        self.liveStockLabel.text = [NSString stringWithFormat:@"x%.f", 0.0];
        self.nextLiveTimeLabel.text = [NSString stringWithFormat:@"%d:0%d", 0, 0];
        if ([[UserData instance] unseenWordCount] > 0) {
            [self hasUnseenWords:YES];
        } else {
            [self hasUnseenWords:NO];
        }
        self.unlockingBoardBool = NO;
        [self unlockBoardSetTo:NO];
        [self hideLabels:[NSNumber numberWithBool:YES]];
    }
    return self;
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
        self.liveStockLabel.textColor = [UIColor orangeColor];
    } else {
        self.liveStockLabel.textColor = [UIColor blackColor];
    }
}


- (void)openBookEndGame {
    [self unlockBoardSetTo:NO];
    [self userInterfaceInWaiting:YES];
    [[[VocabularyTableDialogView alloc] init] show];
}

- (void)generateNewLevelEndGame {
    if ([[UserData instance] hasRetry]) {
        [[UserData instance] decrementRetry];
        [self generateNewLevel];
    } else {
        [[[UpgradeView alloc] initWithBlock:^{
            [self animateLockedBoardToOpen:NO];
            [self userInterfaceInWaiting:YES];
        }] showForKey];
    }
}

- (void)unlockAnswer {
    [self.boardView showAnswer];
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
    //[self showCompleteLevel];
    //[self decrementRetry];
    //[self performSelector:@selector(generateNewLevel) withObject:nil afterDelay:0.0];
}

- (IBAction)answerPressed:(id)sender {
    [[[UpgradeView alloc] init] showForAnswer];
}
- (IBAction)unlockedButtonPressed:(UIButton *)sender {
    if (self.unlockingBoardBool == NO) {
        if ([UserData instance].retry > 0) {
            [self generateNewLevel];
            [self userInterfaceInWaiting:NO];
            [self animateLockedBoardToOpen:YES];
            [self decrementRetry];
            self.unlockingBoardBool = YES;
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
    self.unlockingBoardBool = NO;
}

- (void)unlockBoardSetToWithNSNumber:(NSNumber *)state {
    [self unlockBoardSetTo:[state boolValue]];
}

- (void)animateLockedBoardToOpen:(BOOL)state {
    if (state == NO) {
        [self unlockBoardSetTo:NO];
    }
    [self animateFadeInAndOut:self.lockedBoardView forState:state];
    [self performSelector:@selector(unlockBoardSetToWithNSNumber:) withObject:[NSNumber numberWithBool:state] afterDelay:FADE_DURATION + 0.1f];
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

- (void)generateNewLevel {
    self.currentPrevIndex = [[VocabularyManager instance] unlockUptoLevel];
    NSInteger size = [Utils randBetweenMinInt:10 max:10];
    self.levelData = [[VocabularyManager instance] generateLevel:9
                                                             row:size
                                                             col:size];
    [self.boardView setupWithLevel:self.levelData];
    [self refreshWordList];
    [self updateBubbleCount:[[UserData instance] unseenWordCount]];
    //debug
    //    [self.levelData printAnswers];
}

- (void)refreshWordList {
    // refresh words
    [self updateNextLevel];
    [self.spinner stopAnimating];
    
    for (NSInteger i = 0; i < self.words.count; i++) {
        THLabel *wordLabel = [self.words objectAtIndex:i];
        
        if (i < self.levelData.vocabularyList.count) {
            VocabularyObject *vocabData = [self.levelData.vocabularyList objectAtIndex:i];
            wordLabel.text = vocabData.word;
            //wordLabel.hidden = NO;
            if ([self.levelData.wordsFoundList containsObject:vocabData.word]) {
                wordLabel.alpha = 0.3f;
            } else {
                wordLabel.alpha = 1.f;
                if (![[UserData instance].pokedex containsObject:vocabData.word]) {
                    wordLabel.textColor = [UIColor orangeColor];
                } else {
                    wordLabel.textColor = [UIColor blackColor];
                }
            }
        } else {
            wordLabel.hidden = YES;
        }
    }
    
    // refresh definitions
    NSString *lastWord = [self.levelData.wordsFoundList lastObject];
    if (lastWord) {
        VocabularyObject *lastVocabData = [[VocabularyManager instance] vocabObjectForWord:lastWord];
        self.definitionLabel.text = [NSString stringWithFormat:@"%@: %@", lastVocabData.word, lastVocabData.definition];
    } else {
        self.definitionLabel.text = @". . .";
    }
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
    [self refreshWordList];
    
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
    
    if (self.numOfGame % 3 == 0) {
        [PromoDialogView show];
    }
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

- (void)userInterfaceInWaiting:(BOOL)state {
    
    if (state == NO) {
        self.definitionLabel.hidden = NO;
        self.answerButton.hidden = NO;
        for (THLabel* label in self.words) {
            label.hidden = NO;
        }
    }
    [self animateFadeInAndOut:self.definitionLabel forState:state];
    [self animateFadeInAndOut:self.answerButton forState:state];
    for (THLabel* label in self.words) {
        [self animateFadeInAndOut:label forState:state];
    }
    [self performSelector:@selector(hideLabels:) withObject:[NSNumber numberWithBool:state] afterDelay:FADE_DURATION];
    
}

- (void)hideLabels:(NSNumber *)stateBool {
    BOOL state = [stateBool boolValue];
    self.definitionLabel.hidden = state;
    self.answerButton.hidden = state;
    for (THLabel* label in self.words) {
        label.hidden = state;
    }
}

@end

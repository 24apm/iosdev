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

#define CURRENT_TIME [[NSDate date] timeIntervalSince1970]
#define TIME_FOR_ONE_RETRY 720.0

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

@property (strong, nonatomic) IBOutlet UIImageView *foundNewWordGlowView;
@property (strong, nonatomic) IBOutlet UIImageView *wordBook;
@property (nonatomic) int numOfGame;
@property (nonatomic) double animateDuration;
@property (nonatomic) BOOL animateGlow;


@property (nonatomic) int currentPrevIndex;
@end

@implementation GameView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
        self.newSectionUnlocked = NO;
        [self refillRetryAtStart];
        
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.spinner];
        self.spinner.hidesWhenStopped = YES;
        self.spinner.center = self.definitionLabel.center;
        self.numOfGame = 0;
        self.liveStockLabel.text = [NSString stringWithFormat:@"x%.f", 0.0];
        self.nextLiveTimeLabel.text = [NSString stringWithFormat:@"%d:0%d", 0, 0];
        self.animateGlow = NO;
        if ([[UserData instance] unseenWordCount] > 0) {
            [self openBook];
        }
        [self unlockBoardSetTo:NO];
    }
    return self;
}

- (void)refillRetryAtStart {
    double gapTime = CURRENT_TIME - [UserData instance].retryTime;
    int numberOfRetrySaved = gapTime/TIME_FOR_ONE_RETRY;
    for (int i = 0; i < numberOfRetrySaved; i++) {
        [[UserData instance] refillRetryByOne];
        double newRefillTime = [UserData instance].retryTime + TIME_FOR_ONE_RETRY;
        [[UserData instance] retryRefillStartAt:newRefillTime];
        if ([UserData instance].retry >= [UserData instance].retryCapacity) {
            [[UserData instance] refillRetryAtStart: CURRENT_TIME];
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
            self.nextLiveTimeLabel.text = [NSString stringWithFormat:@"Next in: %d:%0.2d", min, sec];
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
    [[[VocabularyTableDialogView alloc] init] show];
}

- (void)generateNewLevelEndGame {
    if ([[UserData instance] hasRetry]) {
        [[UserData instance] decrementRetry];
        [self generateNewLevel];
    } else {
        [self buyKeyButtonPressed:nil];
        [self animateLockedBoardState:NO];
    }
}

- (void)unlockAnswer {
    [self.boardView showAnswer];
}

- (void)buyMoreCoin {
    [[CoinIAPHelper sharedInstance] showCoinMenu];
}

- (void)updateBubbleCount:(int)count {
    if (count > 0) {
        self.animateGlow = NO;
    } else {
        self.foundNewWordGlowView.hidden = YES;
        self.wordBook.image = [UIImage imageNamed:@"closeBook"];
        self.animateGlow = YES;
    }
}

- (void)setup {
    [self generateNewLevel];
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
    self.newSectionUnlocked = YES;
    //[self showCompleteLevel];
    [self decrementRetry];
    
    [self.spinner startAnimating];
    [self performSelector:@selector(generateNewLevel) withObject:nil afterDelay:0.0];
}

- (IBAction)answerPressed:(id)sender {
    [[[UpgradeView alloc] init] showForAnswer];
}
- (IBAction)unlockedButtonPressed:(UIButton *)sender {
    if ([UserData instance].retry > 0) {
        [self animateLockedBoardState:YES];
        [self decrementRetry];
    } else {
        [[[UpgradeView alloc] init] showForKey];
    }
    
}

- (IBAction)lockedBoardPressed:(UIButton *)sender {
    [self unlockedButtonPressed:sender];
}

- (void)unlockBoardSetTo:(BOOL)state {
    self.lockedBoardView.hidden = state;
}

- (void)animateLockedBoardState:(BOOL)state {
    
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
    fadeInAndOut.autoreverses = YES;
    fadeInAndOut.duration = 1.8f;
    fadeInAndOut.repeatCount = HUGE_VAL;
    [self.lockedBoardView.layer addAnimation:fadeInAndOut forKey:@"fadeInAndOut"];
    [self performSelector:@selector(removeSelfAnimation:) withObject:self.lockedBoardView afterDelay:fadeInAndOut.duration + 0.1f];
    [self performSelector:@selector(unlockBoardSetTo:) withObject:[NSNumber numberWithBool:state] afterDelay:fadeInAndOut.duration + 0.1f];
}

- (void)removeSelfAnimation:(UIView *)view {
    [view.layer removeAllAnimations];
}

- (void)addKey {
    [[UserData instance] refillRetry];
}

- (void)animateAddingKeys {
    [self performSelector:@selector(_animateAddingKeys) withObject:nil afterDelay:1.4f];
}

- (void)_animateAddingKeys {
    int gap = [UserData instance].retryCapacity - [UserData instance].retry;
    double delay = 0;
    
    for (int i = 0; i < gap; i ++) {
        CAEmitterHelperLayer *cellLayer = [CAEmitterHelperLayer emitter:@"particleEffectKeys.json" onView:self];
        cellLayer.cellImage = [UIImage imageNamed:@"key"];
        float x = [Utils randBetweenMin:0 max:self.width];
        
        CGPoint start = CGPointMake(x, self.height);
        
        CGPoint toPoint = self.keyImageView.center;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:start];
        
        CGFloat rand = arc4random() % (int)self.width;
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
    if ([UserData instance].retry < [[UserData instance]retryCapacity]) {
        [[[UpgradeView alloc] init] showForKey];
    }
}

- (void)updateNextLevelLabel {
    int prevLevelCap = [[VocabularyManager instance] mixVocabIndexWith:self.currentPrevIndex -1];
    int currentLevel = [UserData instance].pokedex.count - prevLevelCap;
    int currentLevelCap = [[VocabularyManager instance] mixVocabIndexWith:self.currentPrevIndex] - prevLevelCap;
    
    self.nextLevelLabel.text = [NSString stringWithFormat:@"%d/%d", currentLevel, currentLevelCap];
    if (currentLevel == currentLevelCap) {
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
    [self updateNextLevelLabel];
    [self.spinner stopAnimating];
    
    for (int i = 0; i < self.words.count; i++) {
        THLabel *wordLabel = [self.words objectAtIndex:i];
        
        if (i < self.levelData.vocabularyList.count) {
            VocabularyObject *vocabData = [self.levelData.vocabularyList objectAtIndex:i];
            wordLabel.text = vocabData.word;
            wordLabel.hidden = NO;
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
    [self performSelector:@selector(refreshBubble) withObject:nil afterDelay:0.6f];
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
    if (self.animateGlow == YES) {
        [self performSelector:@selector(animatingExplosion:) withObject:self.wordBook afterDelay:self.animateDuration];
        [self performSelector:@selector(openBook) withObject:nil afterDelay:self.animateDuration + 0.1f];
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
    self.animateDuration = position.duration +.01f;
    [cellLayer addAnimation:position forKey:@"animateIn"];
}

- (void)animatingExplosion:(UIView *)view {
    CAEmitterHelperLayer *cellLayer = [CAEmitterHelperLayer emitter:@"particleEffectFastBurst.json" onView:self];
    CGPoint point = view.center;
    cellLayer.position = point;
}

- (void)animatingExplosionForKey:(UIView *)view {
    CAEmitterHelperLayer *cellLayer = [CAEmitterHelperLayer emitter:@"particleEffectSpark.json" onView:self];
    CGPoint point = view.center;
    cellLayer.position = point;
}

- (void)openBook {
    self.wordBook.image = [UIImage imageNamed:@"openBook"];
    self.foundNewWordGlowView.hidden = NO;
}

@end

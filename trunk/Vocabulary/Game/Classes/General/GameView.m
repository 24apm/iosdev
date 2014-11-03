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

@interface GameView()

@property (strong, nonatomic) IBOutlet UILabel *nextLevelLabel;
@property (strong, nonatomic) BoardView *boardView;
@property (strong, nonatomic) IBOutlet UIView *boardViewContainer;
@property (strong, nonatomic) IBOutletCollection(THLabel) NSArray *words;
@property (strong, nonatomic) IBOutlet UILabel *definitionLabel;
@property (strong, nonatomic) LevelData *levelData;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *wordButton;
@property (nonatomic) BOOL newSectionUnlocked;
@property (strong, nonatomic) IBOutlet UIView *bubbleView;
@property (strong, nonatomic) IBOutlet UILabel *bubbleLabel;
@property (nonatomic) int numOfGame;

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyMoreCoin) name:BUY_COIN_VIEW_NOTIFICATION object:nil];
        self.newSectionUnlocked = NO;
        
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.spinner];
        self.spinner.hidesWhenStopped = YES;
        self.spinner.center = self.definitionLabel.center;
        self.numOfGame = 0;
    }
    return self;
}

- (void)unlockAnswer {
    [self.boardView showAnswer];
}

- (void)buyMoreCoin {
    [[CoinIAPHelper sharedInstance] showCoinMenu];
}

- (void)updateBubbleCount:(int)count {
    if (count > 0) {
        self.bubbleView.hidden = NO;
        self.bubbleLabel.text = [NSString stringWithFormat:@"%d", count];
    } else {
        self.bubbleView.hidden = YES;
    }
}

- (void)setup {
    [self generateNewLevel];
}

- (IBAction)wordPressed:(id)sender {
    [[[VocabularyTableDialogView alloc] init] show];
}

- (IBAction)resetPressed:(id)sender {
    
    [self.spinner startAnimating];
    [self performSelector:@selector(generateNewLevel) withObject:nil afterDelay:0.0];
}

- (IBAction)answerPressed:(id)sender {
    [[[UpgradeView alloc] init] show];
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
        [[[VocabularyTableDialogView alloc] init] show];

        [[[CompletedLevelDialogView alloc] initWithCallback:^{
            [self generateNewLevel];
        }] show];
    } else {
        // no dialog, auto refresh
        [self performSelector:@selector(generateNewLevel) withObject:nil afterDelay:1.0f];
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
}

@end

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

@interface GameView()

@property (strong, nonatomic) BoardView *boardView;
@property (strong, nonatomic) IBOutlet UIView *boardViewContainer;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *words;
@property (strong, nonatomic) IBOutlet UILabel *definitionLabel;
@property (strong, nonatomic) LevelData *levelData;

@end

@implementation GameView

- (void)setup {
    self.boardView = [[BoardView alloc] initWithFrame:CGRectMake(0, 0, self.boardViewContainer.size.width, self.boardViewContainer.size.height)];
    [self.boardViewContainer addSubview:self.boardView];
    [self generateNewLevel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wordMatched:) name:NOTIFICATION_WORD_MATCHED object:nil];

}

- (IBAction)wordPressed:(id)sender {
    [[[VocabularyTableDialogView alloc] init] show];
}

- (IBAction)resetPressed:(id)sender {
    [self generateNewLevel];
}

- (IBAction)answerPressed:(id)sender {
    MessageDialogView *messageDialog = [[MessageDialogView alloc] initWithHeaderText:@"Answer" bodyText:[self.levelData formatFinalAnswer]];
    messageDialog.bodyLabel.font = [UIFont fontWithName:messageDialog.bodyLabel.font.familyName size:6];
    [messageDialog show];
}

- (void)generateNewLevel {
    self.levelData = [[VocabularyManager instance] generateLevel];
    [self refreshWordList];
    [self.boardView setupWithLevel:self.levelData];
    
    [self.levelData printAnswers];
}

- (void)refreshWordList {
    // refresh words
    for (int i = 0; i < self.words.count; i++) {
        UILabel *wordLabel = [self.words objectAtIndex:i];
        
        if (i < self.levelData.vocabularyList.count) {
            VocabularyObject *vocabData = [self.levelData.vocabularyList objectAtIndex:i];
            wordLabel.text = vocabData.word;
            wordLabel.hidden = NO;
            if ([self.levelData.wordsFoundList containsObject:vocabData.word]) {
                wordLabel.alpha = 0.5f;
            } else {
                wordLabel.alpha = 1.f;
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
        self.definitionLabel.text = @"";
    }
}

- (void)wordMatched:(NSNotification *)notification {
    NSString *matchedWord = notification.object;
    [self.levelData.wordsFoundList addObject:matchedWord];

    // update user data
    [[UserData instance] updateDictionaryWith:matchedWord];
    
    [self refreshWordList];
    
    // end game
    if ([[VocabularyManager instance] hasCompletedLevel:self.levelData]) {
        [self performSelector:@selector(generateNewLevel) withObject:nil afterDelay:3.0f];
        NSLog(@"YOU WON!!!");
    }
}

@end

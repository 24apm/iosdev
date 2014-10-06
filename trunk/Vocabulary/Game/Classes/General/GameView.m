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
    for (int i = 0; i < self.words.count; i++) {
        UILabel *wordLabel = [self.words objectAtIndex:i];
        
        if (i < self.levelData.vocabularyList.count) {
            VocabularyObject *vocabData = [self.levelData.vocabularyList objectAtIndex:i];
            wordLabel.text = vocabData.word;
            wordLabel.alpha = 1.f;
            wordLabel.hidden = NO;
        } else {
            wordLabel.hidden = YES;
        }
    }
    self.definitionLabel.text = @"";
}

- (void)wordMatched:(NSNotification *)notification {
    NSString *matchedWord = notification.object;
    
    for (UILabel *word in self.words) {
        if ([word.text isEqualToString:matchedWord]) {
            word.alpha = 0.5f;
        }
    }
    
    for (VocabularyObject *vocabData in self.levelData.vocabularyList) {
        if ([vocabData.word isEqualToString:matchedWord]) {
            self.definitionLabel.text = [NSString stringWithFormat:@"%@: %@", vocabData.word, vocabData.definition];
        }
    }
}

@end

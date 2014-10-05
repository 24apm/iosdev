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
}
- (IBAction)wordPressed:(id)sender {
    [[[VocabularyTableDialogView alloc] init] show];
}
- (IBAction)resetPressed:(id)sender {
    [self generateNewLevel];
}

- (void)generateNewLevel {
    self.levelData = [[VocabularyManager instance] generateLevel];
    [self refreshWordList];
    [self.boardView reset];
}

- (void)refreshWordList {
    for (int i = 0; i < self.words.count; i++) {
        UILabel *wordLabel = [self.words objectAtIndex:i];
        
        if (i < self.levelData.vocabularyList.count) {
            VocabularyObject *vocabData = [self.levelData.vocabularyList objectAtIndex:i];
            wordLabel.text = vocabData.word;
            wordLabel.hidden = NO;
        } else {
            wordLabel.hidden = YES;
        }
    }
}

@end

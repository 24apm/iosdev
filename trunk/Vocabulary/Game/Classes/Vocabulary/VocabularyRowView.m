//
//  VocabularyRowView.m
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VocabularyRowView.h"
#import "VocabularyObject.h"
#import "VocabularyManager.h"

@implementation VocabularyRowView

- (void)setupWithData:(VocabularyObject *)data {
    self.wordLabel.text = data.word;
    
    if ([[VocabularyManager instance] hasUserUnlockedVocab:data.word]) {
        self.wordLabel.alpha = 1.0f;
        self.definitionLabel.alpha = 1.0f;
        self.definitionLabel.text = data.definition;
    } else {
        self.wordLabel.alpha = 0.5f;
        self.definitionLabel.alpha = 0.5f;
        self.definitionLabel.text = @"???";
    }
}

@end

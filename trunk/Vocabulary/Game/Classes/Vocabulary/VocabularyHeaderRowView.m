//
//  VocabularyRowView.m
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VocabularyHeaderRowView.h"
#import "VocabularyObject.h"
#import "VocabularyManager.h"

@implementation VocabularyHeaderRowView

- (void)setupWithData:(VocabularyObject *)data {
    if ([[VocabularyManager instance] hasUserUnlockedVocab:data.word]) {

        self.headerLabel.alpha = 1.0f;
        self.headerLabel.text = data.definition;
    } else {
        self.headerLabel.alpha = 0.3f;
        self.headerLabel.text = @"???";
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    if (_highlighted) {
        self.backgroundView.backgroundColor = [UIColor colorWithRed:75.f/255.f green:211.f/255.f blue:193.f/255.f alpha:0.3f];
    } else {
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
}

@end

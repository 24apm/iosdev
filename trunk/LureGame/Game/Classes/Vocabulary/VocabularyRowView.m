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

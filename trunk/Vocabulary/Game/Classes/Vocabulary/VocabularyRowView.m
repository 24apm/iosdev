//
//  VocabularyRowView.m
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VocabularyRowView.h"
#import "VocabularyObject.h"

@implementation VocabularyRowView

- (void)setupWithData:(VocabularyObject *)data {
    self.wordLabel.text = data.word;
    self.definitionLabel.text = data.definition;
}

@end

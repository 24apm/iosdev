//
//  LevelData.m
//  Vocabulary
//
//  Created by MacCoder on 10/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "LevelData.h"
#import "VocabularyManager.h"
#import "VocabularyObject.h"

@implementation LevelData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.wordsFoundList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)printAnswers {

    NSMutableArray *wordSortedByLength = [NSMutableArray arrayWithArray:[self.answerSheets allKeys]];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [wordSortedByLength sortUsingDescriptors:sortDescriptors];
    
    for (int i = 0; i < wordSortedByLength.count; i++) {
        NSString *key = [wordSortedByLength objectAtIndex:i];
        
        NSLog(@"-- %@ --", key);
        NSLog (@"%@", [[VocabularyManager instance] mapToString:self map:[self.answerSheets objectForKey:key]]);

        NSLog(@"\n\n");
    }
}

- (NSString *)formatFinalAnswer {
    return [[VocabularyManager instance] mapToString:self map:self.finalAnswerSheet];
}



@end

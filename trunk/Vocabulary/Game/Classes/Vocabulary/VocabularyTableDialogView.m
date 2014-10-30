//
//  VocabularyTableDialogView.m
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VocabularyTableDialogView.h"
#import "VocabularyManager.h"
#import "VocabularyTableView.h"
#import "UserData.h"

@implementation VocabularyTableDialogView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.progressLabel.text = [NSString stringWithFormat:@"%d/%d", [VocabularyManager instance].currentCount, [VocabularyManager instance].maxCount];
        [self loadMixedVocabularyDictionary];

    }
    return self;
}

#pragma mark - mixed
- (IBAction)sectionPressed:(id)sender {
    [self loadMixedVocabularyDictionary];
}

- (void)loadMixedVocabularyDictionary {
    NSDictionary *mixedVocabularyDictionary = [[VocabularyManager instance] userMixedVocabList];
    
    // sorting numerically
    // 0 index based
    NSArray *sortedMixedVocabHeaders = [[mixedVocabularyDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue]==[obj2 intValue])
            return NSOrderedSame;
        else if ([obj1 intValue]<[obj2 intValue])
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    // 1 index based array
    NSMutableArray *sortedDisplaySectionIndexes = [NSMutableArray array];
    NSMutableArray *sortedDisplaySectionHeaders = [NSMutableArray array];
    
    for (NSString *index in sortedMixedVocabHeaders) {
        int newIndex = [index integerValue] + 1;
        
        NSString *newIndexKey = [NSString stringWithFormat:@"%d", newIndex];
        [sortedDisplaySectionIndexes addObject:newIndexKey];
        
        NSString *newHeader = [NSString stringWithFormat:@"Level %d", newIndex];
        [sortedDisplaySectionHeaders addObject:newHeader];
    }
    
    [self.tableView setupWithData:sortedDisplaySectionHeaders
                             rows:mixedVocabularyDictionary
            displaySectionIndexes:sortedDisplaySectionIndexes
                   sectionIndexes:sortedMixedVocabHeaders];
    
//    //scroll to last unlocked level
    if (sortedMixedVocabHeaders.count > 0) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:[[VocabularyManager instance] unlockUptoLevel] - 1];
        [self.tableView scrollTo:path];
    }
}

#pragma mark - all vocabulary
- (IBAction)vocabularyPressed:(id)sender {
    [self loadVocabularyDictionary];
}

- (void)loadVocabularyDictionary {
    NSDictionary *vocabularyDictionary = [[VocabularyManager instance] userVocabList];
    
    NSArray *sortedDisplaySectionHeaders = [[vocabularyDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [self.tableView setupWithData:sortedDisplaySectionHeaders
                             rows:vocabularyDictionary
            displaySectionIndexes:sortedDisplaySectionHeaders
                   sectionIndexes:sortedDisplaySectionHeaders];
}

#pragma mark - reset
- (IBAction)resetPressed:(id)sender {
    [[UserData instance] resetUserDefaults];
    [self dismissed:self];
}

@end

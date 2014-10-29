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

- (IBAction)sectionPressed:(id)sender {
    [self loadMixedVocabularyDictionary];
}

- (void)loadMixedVocabularyDictionary {
    NSDictionary *mixedVocabularyDictionary = [[VocabularyManager instance] userMixedVocabList];
    
    NSArray *sortedMixedVocabHeaders = [[mixedVocabularyDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue]==[obj2 intValue])
            return NSOrderedSame;
        else if ([obj1 intValue]<[obj2 intValue])
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    [self.tableView setupWithData:sortedMixedVocabHeaders rows:mixedVocabularyDictionary];

}

- (IBAction)vocabularyPressed:(id)sender {
    [self loadVocabularyDictionary];
}

- (void)loadVocabularyDictionary {
    NSDictionary *vocabularyDictionary = [[VocabularyManager instance] userVocabList];
    
    NSArray *sortedSectionHeaders = [[vocabularyDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [self.tableView setupWithData:sortedSectionHeaders rows:vocabularyDictionary];
}

- (IBAction)resetPressed:(id)sender {
    [[UserData instance] resetUserDefaults];
    [self dismissed:self];
}

@end

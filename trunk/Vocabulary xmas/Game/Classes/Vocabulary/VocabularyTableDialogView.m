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
#import "GameCenterHelper.h"

@interface VocabularyTableDialogView()

@property (nonatomic, strong) NSDictionary *unseenWords;

@end

@implementation VocabularyTableDialogView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.progressLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)[VocabularyManager instance].currentCount, (long)[VocabularyManager instance].maxCount];
        self.unseenWords = [[UserData instance].unseenWords copy];
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
    NSInteger unlockUptoLevel = [[VocabularyManager instance] unlockUptoLevel];
    
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
    NSInteger userPokedex = [UserData instance].pokedex.count;
    NSInteger userLevel = [[VocabularyManager instance] unlockUptoLevel];
    
    for (NSString *index in sortedMixedVocabHeaders) {
        NSInteger newIndex = [index integerValue] + 1;
        
        NSString *newIndexKey = [NSString stringWithFormat:@"%ld", (long)newIndex];
        [sortedDisplaySectionIndexes addObject:newIndexKey];
        
        NSInteger nextLevelIndex = [index integerValue] +1;
        NSInteger prevLevelIndex = [index integerValue];
        NSInteger currentLevelCap = [[VocabularyManager instance] mixVocabIndexWith:nextLevelIndex] - [[VocabularyManager instance] mixVocabIndexWith:prevLevelIndex];
        NSInteger currentLevel = 0;
        if (userLevel == [index integerValue] + 1) {
            currentLevel = userPokedex - [[VocabularyManager instance] mixVocabIndexWith:prevLevelIndex];
        } else {
            currentLevel = currentLevelCap;
        }
        
        NSString *newHeader;
        if ([index intValue] < unlockUptoLevel) {
            newHeader = [NSString stringWithFormat:@"[Level %ld] %ld/%ld", (long)newIndex, (long)currentLevel, (long)currentLevelCap];
        } else {
            newHeader = [NSString stringWithFormat:@"[Level %ld] Locked",(long) newIndex];
        }
        [sortedDisplaySectionHeaders addObject:newHeader];
    }
    
    [self.tableView setupWithData:sortedDisplaySectionHeaders
                             rows:mixedVocabularyDictionary
            displaySectionIndexes:sortedDisplaySectionIndexes
                   sectionIndexes:sortedMixedVocabHeaders
                      unseenWords:self.unseenWords];
    
//    //scroll to last unlocked level
    if (sortedMixedVocabHeaders.count > 0) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:unlockUptoLevel - 1];
        [self.tableView scrollTo:path];
    }
}

#pragma mark - all vocabulary
- (IBAction)vocabularyPressed:(id)sender {
    [self loadVocabularyDictionary];
}

- (IBAction)leaderboardPressed:(id)sender {
    [[GameCenterHelper instance] showLeaderboard:[Utils rootViewController]];
}

- (void)loadVocabularyDictionary {
    NSDictionary *vocabularyDictionary = [[VocabularyManager instance] userVocabList];
    
    NSArray *sortedDisplaySectionHeaders = [[vocabularyDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [self.tableView setupWithData:sortedDisplaySectionHeaders
                             rows:vocabularyDictionary
            displaySectionIndexes:sortedDisplaySectionHeaders
                   sectionIndexes:sortedDisplaySectionHeaders
                      unseenWords:self.unseenWords];
}

#pragma mark - reset
- (IBAction)resetPressed:(id)sender {
    [[UserData instance] resetUserDefaults];
    [self dismissed:self];
}

- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VocabularyTableDialogViewDimissed object:nil];
    [super dismissed:sender];
}

@end

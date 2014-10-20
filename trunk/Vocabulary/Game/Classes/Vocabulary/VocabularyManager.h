//
//  VocabularyManager.h
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelData.h"
#import "VocabularyObject.h"

#define NUM_COL 12
#define NUM_ROW 12

@interface VocabularyManager : NSObject

+ (VocabularyManager *)instance;
- (NSDictionary *)vocabList;
- (NSDictionary *)userVocabList;

- (void)loadFile;

- (int)currentCount;
- (int)maxCount;

- (NSString *)randomLetter;

- (void)printMap:(LevelData *)levelData;
- (void)printAnswer:(LevelData *)levelData;
- (NSString *)mapToString:(LevelData *)levelData map:(NSArray *)map;

- (LevelData *)generateLevel:(NSInteger)numOfWords row:(NSInteger)row col:(NSInteger)col;
- (VocabularyObject *)vocabObjectForWord:(NSString *)word;

- (BOOL)checkSolution:(LevelData *)levelData word:(NSString *)word;

- (BOOL)hasCompletedLevel:(LevelData *)levelData;

@end

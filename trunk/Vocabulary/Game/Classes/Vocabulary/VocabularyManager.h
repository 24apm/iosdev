//
//  VocabularyManager.h
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelData.h"

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

- (LevelData *)generateLevel;
- (void)printMap:(NSArray *)map;
- (NSString *)mapToString:(NSArray *)map;

- (BOOL)checkSolution:(LevelData *)levelData word:(NSString *)word;

@end

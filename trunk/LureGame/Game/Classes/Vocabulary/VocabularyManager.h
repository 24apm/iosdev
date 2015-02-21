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

#define NUM_COL 10
#define NUM_ROW 10

@interface VocabularyManager : NSObject

+ (VocabularyManager *)instance;

- (NSUInteger)currentCount;
- (NSUInteger)maxCount;
- (NSString *)mapToString:(LevelData *)levelData map:(NSArray *)map;

- (LevelData *)generateLevel;
- (VocabularyObject *)vocabObjectForWord:(NSString *)word;

@end

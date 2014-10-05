//
//  VocabularyManager.h
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelData.h"

@interface VocabularyManager : NSObject

+ (VocabularyManager *)instance;
- (NSDictionary *)vocabList;

- (void)loadFile;

- (int)currentCount;
- (int)maxCount;

- (NSString *)randomLetter;

- (LevelData *)generateLevel;


@end

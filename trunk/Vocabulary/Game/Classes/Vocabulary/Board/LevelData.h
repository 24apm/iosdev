//
//  LevelData.h
//  Vocabulary
//
//  Created by MacCoder on 10/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelData : NSObject

@property (strong, nonatomic) NSArray *vocabularyList;
@property (strong, nonatomic) NSArray *letterMap;
@property (strong, nonatomic) NSMutableDictionary *answerSheets;
@property (strong, nonatomic) NSArray *finalAnswerSheet;

- (void)printAnswers;
- (NSString *)formatFinalAnswer;

@end

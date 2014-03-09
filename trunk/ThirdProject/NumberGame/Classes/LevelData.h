//
//  LevelData.h
//  What Number
//
//  Created by MacCoder on 3/8/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelData : NSObject
@property (nonatomic) int minChoiceValue;
@property (nonatomic) int maxChoiceValue;
@property (nonatomic) int choiceSlotCount;
@property (nonatomic) int answerSlotCount;
@property (nonatomic, strong) NSArray *operation;

+ (LevelData *)levelConfigForCurrentScore:(int)score;

@end

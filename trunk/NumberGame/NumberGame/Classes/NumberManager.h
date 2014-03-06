//
//  NumberManager.h
//  NumberGame
//
//  Created by MacCoder on 2/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberManager : NSObject

+ (NumberManager *)instance;
- (NSDictionary *)generateLevel:(int)answerSlots choiceSlots:(int)choiceSlots;
- (BOOL)checkAlgebra:(NSArray *)algrebra targetValue:(float)targetValue;
- (NSArray *)generateAlgebraFor:(int)input;
- (BOOL)isOperator:(id)object;
- (NSMutableArray *)currentGeneratedAnswerInStrings;

@property (nonatomic, retain) NSMutableArray *currentGeneratedAnswer;
@property (nonatomic, retain) NSMutableArray *currentGeneratedFillerAnswer;
@property (nonatomic, retain) NSMutableArray *currentGeneratedShuffledAnswer;
@property (nonatomic) int targetAnswer;
@end

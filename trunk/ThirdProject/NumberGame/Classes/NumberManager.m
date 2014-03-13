//
//  NumberManager.m
//  NumberGame
//
//  Created by MacCoder on 2/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "NumberManager.h"
#import "Utils.h"
#import "LevelData.h"
#import "GameConstants.h"

@interface NumberManager()
@property (nonatomic, strong) LevelData *currentLevelData;
@end

@implementation NumberManager

+ (NumberManager *)instance {
    static NumberManager *instance = nil;
    if (!instance) {
        instance = [[NumberManager alloc] init];
    }
    return instance;
}

- (NSDictionary *)generateLevel:(LevelData *)levelData {
    int divNum = 0;
    int plusLoop = 0;
    int minusLoop = 0;
    int multiLoop = 0;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    // do stuff
    self.currentLevelData = levelData;
    int tiles = levelData.answerSlotCount;
    for (int j = 0; j < 2000; j++) {
        NSMutableArray *algebra = [NSMutableArray arrayWithArray: [self generateAlgebraFor:tiles]];
        int numberIndex = 2;
        int operatorIndex = 1;
        int targetNumber = [((NSNumber *)algebra[0])intValue];
        int nextNumber = [((NSNumber *)algebra[numberIndex])intValue];
        NSString *operator = [algebra objectAtIndex:operatorIndex];
        for (int i = 0; i <= tiles - 3; i = i + 2) {
            
            if ([operator isEqualToString:SYMBOL_OPERATION_MULTIPLICATION]) {
                multiLoop++;
                targetNumber = targetNumber * nextNumber;
            } else if ([operator isEqualToString:SYMBOL_OPERATION_ADDITION]) {
                plusLoop++;
                targetNumber = targetNumber + nextNumber;
            } else if ([operator isEqualToString:SYMBOL_OPERATION_SUBTRACTION]) {
                minusLoop++;
                targetNumber = targetNumber - nextNumber;
            } else if ([operator isEqualToString:SYMBOL_OPERATION_DIVSION]) {
                int newDivide = [self divideNumber:targetNumber];
                if (nextNumber != 0 && targetNumber % nextNumber == 0) {
                    targetNumber = targetNumber / nextNumber;
                    divNum++;
                } else if (newDivide != 1){
                    targetNumber = targetNumber / newDivide;
                    [algebra replaceObjectAtIndex:numberIndex withObject:[NSNumber numberWithInt:newDivide]];
                    divNum++;
                    
                } else {
                    int reset = [Utils randBetweenMinInt:0 max:2];
                    switch (reset) {
                        case 0:
                            targetNumber = targetNumber * nextNumber;
                            [algebra replaceObjectAtIndex:operatorIndex withObject:SYMBOL_OPERATION_MULTIPLICATION];
                            multiLoop++;
                            break;
                        case 1:
                            targetNumber = targetNumber - nextNumber;
                            [algebra replaceObjectAtIndex:operatorIndex withObject:SYMBOL_OPERATION_SUBTRACTION];
                            minusLoop++;
                            break;
                        case 2:
                            targetNumber = targetNumber + nextNumber;
                            [algebra replaceObjectAtIndex:operatorIndex withObject:SYMBOL_OPERATION_ADDITION];
                            plusLoop++;
                            break;
                        default:
                            targetNumber = targetNumber * nextNumber;
                            [algebra replaceObjectAtIndex:operatorIndex withObject:SYMBOL_OPERATION_MULTIPLICATION];
                            multiLoop++;
                            break;
                    }
                }
            }
            if (numberIndex + 2 <= tiles) {
                numberIndex += 2;
                operatorIndex += 2;
                nextNumber = [[algebra objectAtIndex:numberIndex]intValue];
                operator = [algebra objectAtIndex:operatorIndex];
            }
        }
        
        self.currentGeneratedAnswer = [algebra mutableCopy];
        
        // adding fillers
        NSInteger algebraSize = algebra.count;
        NSArray *operatorArr = self.currentLevelData.operation;
        while (algebraSize < levelData.choiceSlotCount) {
            NSInteger randomNumOp = self.currentLevelData.maxChoiceValue + operatorArr.count;
            int filler = [Utils randBetweenMinInt:self.currentLevelData.minChoiceValue max:randomNumOp];
            if (filler > self.currentLevelData.maxChoiceValue) {
                [algebra addObject:[operatorArr objectAtIndex:filler - self.currentLevelData.maxChoiceValue - 1]];
                algebraSize++;
            } else {
                NSNumber *addFiller = [NSNumber numberWithInt:filler];
                [algebra addObject:addFiller];
                algebraSize++;
            }
        }
        self.currentGeneratedFillerAnswer = [algebra mutableCopy];
        self.targetAnswer = targetNumber;
        [algebra shuffle];
        [dictionary setObject:algebra forKey:@"algebra"];
        [dictionary setObject:@(targetNumber) forKey:@"targetNumber"];
        [dictionary setObject:[[NumberManager instance] currentGeneratedAnswerInStrings] forKey:@"currentGeneratedAnswerInStrings"];
        // Dictionary:
        // "algrebra" => ["12", "+", "32", "-", "2", ...],
        // "targetValue" => 123
        self.currentGeneratedShuffledAnswer = [algebra mutableCopy];
    }
    return dictionary;
}

- (BOOL)checkAlgebra:(NSArray *)algebra targetValue:(float)targetValue {
    
    BOOL isCorrect = NO;
    NSInteger tiles = algebra.count;
    int numberIndex = 2;
    int operatorIndex = 1;
    float attemptAnswer = [((NSNumber *)algebra[0])intValue];
    float nextNumber = [((NSNumber *)algebra[numberIndex])intValue];
    NSString *operator = algebra[operatorIndex];
    for (int i = 0; i <= tiles - 3; i = i + 2) {
        attemptAnswer = [self calculateWithOperandLeft:attemptAnswer operator:operator operandRight:nextNumber];
        if (numberIndex + 2 <= tiles) {
            numberIndex += 2;
            operatorIndex += 2;
            nextNumber = [((NSNumber *)algebra[numberIndex])intValue];
            operator = algebra[operatorIndex];
        }
    }
    if (targetValue == attemptAnswer){
        isCorrect = YES;
    }
    
    // check for algebra
    // "algrebra" => ["12", "+", "32", "-", "2", ...], == targetValue
    // return YES if equal
    // else     NO if not
    
    return isCorrect;
}

- (float)calculateWithOperandLeft:(float)operandLeft operator:(NSString *)op operandRight:(float)operandRight {
    
    float total = 0.f;
    if ([op isEqualToString:SYMBOL_OPERATION_MULTIPLICATION]) {
        total = operandLeft * operandRight;
    } else if ([op isEqualToString:SYMBOL_OPERATION_ADDITION]) {
        total = operandLeft + operandRight;
    } else if ([op isEqualToString:SYMBOL_OPERATION_SUBTRACTION]) {
        total = operandLeft - operandRight;
    } else if ([op isEqualToString:SYMBOL_OPERATION_DIVSION]) {
        total = operandLeft / operandRight;
    }
    return total;
}

- (NSArray *)generateAlgebraFor:(int)input {
    NSArray *operator = self.currentLevelData.operation;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < input; i++) {
        if (i % 2 == 0) {
            [array addObject:[NSNumber numberWithInt:[Utils randBetweenMinInt:self.currentLevelData.minChoiceValue max:self.currentLevelData.maxChoiceValue]]];
        } else {
            int op = [Utils randBetweenMinInt:0 max:operator.count - 1];
            [array addObject:operator[op]];
        }
    }
    return array;
}

- (NSMutableArray *)stringConverter:(NSArray *)algebra {
    NSMutableArray *attemptAnswer = [NSMutableArray array];
    for (int i = 0; i < algebra.count; i++) {
        if ([[algebra objectAtIndex:i] isKindOfClass:[NSNumber class]]) {
            NSString *string = [NSString stringWithFormat: @"%d",[[algebra objectAtIndex:i] intValue]];
            [attemptAnswer addObject:string];
        } else {
            [attemptAnswer addObject:[algebra objectAtIndex:i]];
        }
    }
    return attemptAnswer;
}

- (BOOL)isOperator:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        NSArray *operators = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        NSString *temp = object;
        for (NSString *op in operators) {
            if ([temp isEqualToString:op]) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSMutableArray *)currentGeneratedAnswerInStrings {
    return [self stringConverter:self.currentGeneratedAnswer];
}

- (int) divideNumber:(int)currentNumber {
    int divideBy = 10;
    while (currentNumber % divideBy != 0) {
        divideBy--;
        if (divideBy < 2) {
            return divideBy;
        }
    }
    return divideBy;
}
@end

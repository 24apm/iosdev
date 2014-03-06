//
//  NumberManager.m
//  NumberGame
//
//  Created by MacCoder on 2/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "NumberManager.h"
#import "Utils.h"

@interface NumberManager()

@end

@implementation NumberManager

+ (NumberManager *)instance {
    static NumberManager *instance = nil;
    if (!instance) {
        instance = [[NumberManager alloc] init];
    }
    return instance;
}

- (NSDictionary *)generateLevel:(int)answerSlots choiceSlots:(int)choiceSlots {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    // do stuff
    int tiles = answerSlots;
    
    NSMutableArray *algebra = [NSMutableArray arrayWithArray:[self generateAlgebraFor:tiles]];
    int numberIndex = 2;
    int operatorIndex = 1;
    int targetNumber = [((NSNumber *)algebra[0])intValue];
    int nextNumber = [((NSNumber *)algebra[numberIndex])intValue];
    NSString *operator = [algebra objectAtIndex:operatorIndex];
    for (int i = 0; i <= tiles - 3; i = i + 2) {
        
        if ([operator isEqualToString:@"×"]) {
            targetNumber = targetNumber * nextNumber;
        } else if ([operator isEqualToString:@"+"]) {
            targetNumber = targetNumber + nextNumber;
        } else if ([operator isEqualToString:@"-"]) {
            targetNumber = targetNumber - nextNumber;
        } else if ([operator isEqualToString:@"÷"]) {
            if (targetNumber % nextNumber == 0) {
                targetNumber = targetNumber / nextNumber;
            } else {
                int reset = [Utils randBetweenMinInt:0 max:2];
                switch (reset) {
                    case 0:
                        targetNumber = targetNumber * nextNumber;
                        [algebra replaceObjectAtIndex:operatorIndex withObject:@"×"];
                        break;
                    case 1:
                        targetNumber = targetNumber - nextNumber;
                        [algebra replaceObjectAtIndex:operatorIndex withObject:@"-"];
                        break;
                    case 2:
                        targetNumber = targetNumber + nextNumber;
                        [algebra replaceObjectAtIndex:operatorIndex withObject:@"+"];
                        break;
                    default:
                        targetNumber = targetNumber * nextNumber;
                        [algebra replaceObjectAtIndex:operatorIndex withObject:@"×"];
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
    int algebraSize = algebra.count;
    int maxNumberRange = 10;
    NSArray *operatorArr = @[@"+", @"-", @"×", @"÷"];
    while (algebraSize < choiceSlots) {
        int randomNumOp = maxNumberRange + operatorArr.count;
        int filler = [Utils randBetweenMinInt:1 max:randomNumOp];
        if (filler > maxNumberRange) {
            [algebra addObject:[operatorArr objectAtIndex:filler - maxNumberRange - 1]];
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
    // Dictionary:
    // "algrebra" => ["12", "+", "32", "-", "2", ...],
    // "targetValue" => 123
    self.currentGeneratedShuffledAnswer = [algebra mutableCopy];

    return dictionary;
}

- (BOOL)checkAlgebra:(NSArray *)algebra targetValue:(float)targetValue {
    
    BOOL isCorrect = NO;
    int tiles = algebra.count;
    int numberIndex = 2;
    int operatorIndex = 1;
    int attemptAnswer = [((NSNumber *)algebra[0])intValue];
    int nextNumber = [((NSNumber *)algebra[numberIndex])intValue];
    NSString *operator = algebra[operatorIndex];
    for (int i = 0; i <= tiles - 3; i = i + 2) {
        if ([operator isEqualToString:@"×"]) {
            attemptAnswer = attemptAnswer * nextNumber;
        } else if ([operator isEqualToString:@"+"]) {
            attemptAnswer = attemptAnswer + nextNumber;
        } else if ([operator isEqualToString:@"-"]) {
            attemptAnswer = attemptAnswer - nextNumber;
        } else if ([operator isEqualToString:@"÷"]) {
            attemptAnswer = attemptAnswer / nextNumber;
        }
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

- (NSArray *)generateAlgebraFor:(int)input {
    NSArray *operator = @[@"+", @"-", @"×", @"÷"];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < input; i++) {
        if (i % 2 == 0) {
            [array addObject:[NSNumber numberWithInt:[Utils randBetweenMinInt:1 max:10]]];
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
        NSArray *operators = @[@"+", @"-", @"×", @"÷"];
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

@end

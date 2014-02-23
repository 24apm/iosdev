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

- (NSDictionary *)generateLevel {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    // do stuff
    int tiles = 3;
    int choiceSlots = 9;
    NSMutableArray *algebra = [NSMutableArray arrayWithArray:[self generateAnswerFor:tiles]];
    int numberIndex = 2;
    int operatorIndex = 1;
    int targetNumber = [((NSNumber *)algebra[0])intValue];
    int nextNumber = [((NSNumber *)algebra[numberIndex])intValue];
    NSString *operator = algebra[operatorIndex];
    for (int i = 0; i <= tiles - 3; i = i + 2) {
        if ([operator isEqualToString:@"*"]) {
            targetNumber = targetNumber * nextNumber;
        } else if ([operator isEqualToString:@"+"]) {
            targetNumber = targetNumber + nextNumber;
        } else if ([operator isEqualToString:@"-"]) {
            targetNumber = targetNumber - nextNumber;
        } else if ([operator isEqualToString:@"/"]) {
            if (targetNumber % nextNumber == 0) {
                targetNumber = targetNumber / nextNumber;
            } else {
                int reset = [Utils randBetweenMinInt:0 max:2];
                switch (reset) {
                    case 0:
                        targetNumber = targetNumber * nextNumber;
                        algebra[operatorIndex] = @"*";
                        break;
                    case 1:
                        targetNumber = targetNumber - nextNumber;
                        algebra[operatorIndex] = @"-";
                        break;
                    case 2:
                        targetNumber = targetNumber + nextNumber;
                        algebra[operatorIndex] = @"+";
                        break;
                    default:
                        targetNumber = targetNumber * nextNumber;
                        algebra[operatorIndex] = @"*";
                        break;
                }
            }
        }
        if (numberIndex + 2 <= tiles) {
            numberIndex += 2;
            operatorIndex += 2;
            nextNumber = [((NSNumber *)algebra[numberIndex])intValue];
            operator = algebra[operatorIndex];
        }
    }
    int algebraSize = algebra.count-1;
    int maxNumberRange = 10;
    while (algebraSize < choiceSlots) {
        int randomNumOp = maxNumberRange + 4;
        int filler = [Utils randBetweenMinInt:1 max:randomNumOp];
        if (filler > maxNumberRange) {
            NSArray *operator = @[@"+", @"-", @"*", @"/"];
            int op = [Utils randBetweenMinInt:0 max:operator.count - 1];
            [algebra addObject:operator[op]];
            algebraSize++;
        } else {
            NSNumber *addFiller = [NSNumber numberWithInt:filler];
            [algebra addObject:addFiller];
            algebraSize++;
        }
    }
    
    //for (int i = 0; i < 10; i++) {
      //  NSMutableArray *test = [NSMutableArray arrayWithArray:@[@(1),@(2),@(3),@(4),@(5),@(6),@"7",@"8",@"9"]];
        //[test randomArray];
        //NSLog(@"%@", test);
 //   }
    
    [algebra randomArray];
    [dictionary setObject:algebra forKey:@"algebra"];
    [dictionary setObject:@(targetNumber) forKey:@"targetNumber"];
    // Dictionary:
    // "algrebra" => ["12", "+", "32", "-", "2", ...],
    // "targetValue" => 123

    return dictionary;
}

- (BOOL)checkAlgebra:(NSArray *)algebra targetValue:(float)targetValue {
    
    BOOL isCorrect = NO;
    NSMutableArray *answer;
    answer = [NSMutableArray arrayWithArray:[self stringConverter:algebra]];
    int tiles = 3;
    int numberIndex = 2;
    int operatorIndex = 1;
    int attemptAnswer = [((NSNumber *)algebra[0])intValue];
    int nextNumber = [((NSNumber *)algebra[numberIndex])intValue];
    NSString *operator = algebra[operatorIndex];
    for (int i = 0; i <= tiles - 3; i = i + 2) {
        if ([operator isEqualToString:@"*"]) {
            attemptAnswer = attemptAnswer * nextNumber;
        } else if ([operator isEqualToString:@"+"]) {
            attemptAnswer = attemptAnswer + nextNumber;
        } else if ([operator isEqualToString:@"-"]) {
            attemptAnswer = attemptAnswer - nextNumber;
        } else if ([operator isEqualToString:@"/"]) {
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

- (NSArray *)generateAnswerFor:(int)input {
    NSArray *operator = @[@"+", @"-", @"*", @"/"];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < input; i++) {
        int test = i % 2;
        if (test <= 0) {
        array[i] = [NSNumber numberWithInt:[Utils randBetweenMinInt:1 max:10]];
        } else {
            int op = [Utils randBetweenMinInt:0 max:operator.count - 1];
            array[i] = operator[op];
        }
    }
    return array;
    
}

- (NSArray *)stringConverter:(NSArray *)algebra {
    NSMutableArray *attemptAnswer;
    for (int i = 0; i < algebra.count; i++) {
        if (i % 2) {
            NSNumber *number;
            number = [algebra objectAtIndex:i];
            [[attemptAnswer objectAtIndex:i] addObject:number];
        } else {
            [[attemptAnswer objectAtIndex:i] addObject:[algebra objectAtIndex:i]];
        }
    }
        return attemptAnswer;
}
@end

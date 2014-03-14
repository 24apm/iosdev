//
//  LevelData.m
//  What Number
//
//  Created by MacCoder on 3/8/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "LevelData.h"
#import "GameConstants.h"

@implementation LevelData

+ (LevelData *)levelConfigForCurrentScore:(int)score {
    LevelData *levelData = [[LevelData alloc] init];
    //score = 800;
    if (score < 1) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 1;
    } else if (score < 6) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 5;
    } else if (score < 11) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 7;
    } else if (score < 16) {
        levelData.operation = @[SYMBOL_OPERATION_MULTIPLICATION];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 10;
    } else if (score < 21) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 10;
    } else if (score < 31) {
        levelData.operation = @[SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 10;
    } else if (score < 41) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 10;
    } else if (score < 51) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -4;
        levelData.maxChoiceValue = 10;
    } else if (score < 61) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -10;
        levelData.maxChoiceValue = 10;
    } else if (score < 76) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -15;
        levelData.maxChoiceValue = 15;
    } else if (score < 91) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -20;
        levelData.maxChoiceValue = 20;
    } else if (score < 116) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -25;
        levelData.maxChoiceValue = 25;
    } else if (score < 131) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -30;
        levelData.maxChoiceValue = 30;
    } else if (score < 151) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -35;
        levelData.maxChoiceValue = 35;
    } else if (score < 171) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -40;
        levelData.maxChoiceValue = 40;
    } else if (score < 201) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -45;
        levelData.maxChoiceValue = 45;
    } else if (score < 251) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -50;
        levelData.maxChoiceValue = 50;
    } else if (score < 351) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -55;
        levelData.maxChoiceValue = 55;
    } else if (score < 501) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -60;
        levelData.maxChoiceValue = 60;
    } else if (score < 901) {
        levelData.operation = @[SYMBOL_OPERATION_ADDITION, SYMBOL_OPERATION_SUBTRACTION, SYMBOL_OPERATION_MULTIPLICATION, SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -70;
        levelData.maxChoiceValue = 70;
    } else {
        levelData.operation = @[SYMBOL_OPERATION_DIVSION];
        levelData.minChoiceValue = -99;
        levelData.maxChoiceValue = 99;
    }
    
    return levelData;
}

@end

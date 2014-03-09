//
//  LevelData.m
//  What Number
//
//  Created by MacCoder on 3/8/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "LevelData.h"

@implementation LevelData

+ (LevelData *)levelConfigForCurrentScore:(int)score {
    LevelData *levelData = [[LevelData alloc] init];
    if (score < 1) {
        levelData.operation = @[@"+"];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 1;
    } else if (score < 5) {
        levelData.operation = @[@"+"];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 5;
    } else if (score < 10) {
        levelData.operation = @[@"+", @"-"];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 7;
    } else if (score < 15) {
        levelData.operation = @[@"*"];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 10;
    } else if (score < 20) {
        levelData.operation = @[@"+", @"-", @"*"];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 10;
    } else if (score < 30) {
        levelData.operation = @[@"%"];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 10;
    } else if (score < 40) {
        levelData.operation = @[@"+", @"-", @"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 10;
    } else if (score < 50) {
        levelData.operation = @[@"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = -4;
        levelData.maxChoiceValue = 10;
    } else if (score < 60) {
        levelData.operation = @[@"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = -10;
        levelData.maxChoiceValue = 10;
    } else if (score < 75) {
        levelData.operation = @[@"+", @"-", @"*", @"%", @"*", @"%"];
        levelData.minChoiceValue = -15;
        levelData.maxChoiceValue = 15;
    } else if (score < 90) {
        levelData.operation = @[@"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = -20;
        levelData.maxChoiceValue = 20;
    } else if (score < 115) {
        levelData.operation = @[@"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = -25;
        levelData.maxChoiceValue = 25;
    } else if (score < 130) {
        levelData.operation = @[@"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = -30;
        levelData.maxChoiceValue = 30;
    } else if (score < 150) {
        levelData.operation = @[@"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = -35;
        levelData.maxChoiceValue = 35;
    } else if (score < 170) {
        levelData.operation = @[@"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = -40;
        levelData.maxChoiceValue = 40;
    } else if (score < 200) {
        levelData.operation = @[@"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = -45;
        levelData.maxChoiceValue = 45;
    } else if (score < 250) {
        levelData.operation = @[@"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = -50;
        levelData.maxChoiceValue = 50;
    } else if (score < 350) {
        levelData.operation = @[@"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = -55;
        levelData.maxChoiceValue = 55;
    } else if (score < 500) {
        levelData.operation = @[@"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = -60;
        levelData.maxChoiceValue = 60;
    } else if (score < 900) {
        levelData.operation = @[@"+", @"-", @"*", @"%"];
        levelData.minChoiceValue = -70;
        levelData.maxChoiceValue = 70;
    } else {
        levelData.operation = @[@"÷"];
        levelData.minChoiceValue = -99;
        levelData.maxChoiceValue = 99;
    }
    
    return levelData;
}

@end

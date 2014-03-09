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
        levelData.operation = @[@"+" ];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 1;
    } else{
        levelData.operation = @[@"÷"];
        levelData.minChoiceValue = 1;
        levelData.maxChoiceValue = 99;
    }
    
    return levelData;
}

@end

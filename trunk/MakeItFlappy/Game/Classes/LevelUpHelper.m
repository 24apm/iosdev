//
//  LevelUpHelper.m
//  Make It Flappy
//
//  Created by MacCoder on 6/9/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "LevelUpHelper.h"
#import "UserData.h"

@implementation LevelUpHelper

+ (int)levelExpCheck:(LevelUpType)type currentLevel:(int)level {
    int lvlExpNeeded = 0;
    switch (type) {
        case LevelUpTypeBurst:
            lvlExpNeeded = [UserData instance].burstCost * level;
            break;
        case LevelUpTypeStamina:
            lvlExpNeeded = [UserData instance].staminaCost * level;
            break;
        case LevelUpTypeFlappy:
            lvlExpNeeded = [UserData instance].flappyCost * level;
            break;
            
        default:
            break;
    }
    return lvlExpNeeded;
}

@end

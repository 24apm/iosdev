//
//  GameManager.m
//  SequenceGame
//
//  Created by MacCoder on 3/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameManager.h"
#import "GameConstants.h"

@implementation GameManager

+ (GameManager *)instance {
    static GameManager *instance = nil;
    if (!instance) {
        instance = [[GameManager alloc] init];
    }
    return instance;
}

- (void)generatelevel {
    self.step = 0;
    self.unitQueue = [NSMutableArray array];
    NSArray *units = @[@(UnitTypeArrow), @(UnitTypeMonster)];
    for (int i = 0; i < 50; i++) {
        [self.unitQueue addObject:[units randomObject]];
    }
    [self.unitQueue addObject:[NSNumber numberWithInt:UnitTypeBoss]];
}

- (void)sequenceCaculation:(UserInput)input {
    if (self.step >= self.unitQueue.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GAMEPLAY_VIEW_VICTORY_NOTIFICATION object:nil];
    }
    if(([[self.unitQueue objectAtIndex:self.step] integerValue] == UnitTypeArrow && input == UserInputDefend) ||
       ([[self.unitQueue objectAtIndex:self.step] integerValue] == UnitTypeMonster && input == UserInputAttack) ||
        ([[self.unitQueue objectAtIndex:self.step] integerValue] == UnitTypeBoss && input == UserInputAttack)) {
        self.step++;
        [[NSNotificationCenter defaultCenter] postNotificationName:GAME_MANAGER_REFRESH_NOTIFICATION object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:GAME_MANAGER_END_GAME_NOTIFICATION object:nil];
    }
    if (self.step >= self.unitQueue.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GAMEPLAY_VIEW_VICTORY_NOTIFICATION object:nil];
    }

}

- (NSArray *)currentVisibleQueue {
    NSRange range = NSMakeRange(self.step, MIN(self.unitQueue.count - self.step,4));
    return [self.unitQueue subarrayWithRange:range];
}

- (NSString *)imagePathFor:(UnitType)unitType {
    switch (unitType) {
        case UnitTypeArrow:
            return IMAGE_ARROW;
            break;
        case UnitTypeMonster:
            return IMAGE_MONSTER;
            break;
        case UnitTypeBoss:
            return IMAGE_BOSS;
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)imagePathForUserInput:(UserInput)userInput {
    switch (userInput) {
        case UserInputAttack:
            return @"attack.png";
            break;
        case UserInputDefend:
            return @"defend.png";
            break;
        default:
            return nil;
            break;
    }
}


@end

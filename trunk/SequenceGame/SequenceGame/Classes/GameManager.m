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
        UnitType unitType = [[units randomObject] integerValue];
        [self.unitQueue addObject:[[MonsterData alloc] initWithUnitType:unitType]];
    }
    [self.unitQueue addObject:[[MonsterData alloc] initWithUnitType:UnitTypeBoss]];
}

- (void)sequenceCaculation:(UserInput)input {
    if (self.step >= self.unitQueue.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GAMEPLAY_VIEW_VICTORY_NOTIFICATION object:nil];
    }
    MonsterData *monsterData = [self.unitQueue objectAtIndex:self.step];
    
    if((monsterData.unitType == UnitTypeArrow && input == UserInputDefend) ||
       (monsterData.unitType == UnitTypeMonster && input == UserInputAttack) ||
       (monsterData.unitType == UnitTypeBoss && input == UserInputAttack)) {
        monsterData.hp--;
        if (monsterData.hp <= 0) {
            self.step++;
        }
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

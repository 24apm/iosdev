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

- (void)generatelevelForTime {
    self.unitQueue = [NSMutableArray array];
    for (int i = 0; i < 1000; i++) {
        [self.unitQueue addObject:[self generateNextRandomUnit]];
    }
}

- (MonsterData *)generateNextRandomUnit {
    NSArray *units = @[@(UnitTypeArrow), @(UnitTypeMonster), @(UnitTypeMaterialWeapon), @(UnitTypeMaterialShield), @(UnitTypeEnergy)];
    UnitType unitType = [[units randomObject] integerValue];
    MonsterData *monsterData = [[MonsterData alloc] initWithUnitType:unitType];
    return monsterData;
}

- (void)sequenceCaculation:(UserInput)input {
    MonsterData *monsterData = [self.unitQueue objectAtIndex:0];
    
    if([monsterData isValidUserInput:input]) {
        monsterData.hp--;
        if (monsterData.hp <= 0) {
            [self.unitQueue dequeue];
            [self.unitQueue enqueue:[self generateNextRandomUnit]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:GAME_MANAGER_REFRESH_NOTIFICATION object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:GAME_MANAGER_END_GAME_NOTIFICATION object:nil];
    }
}

- (NSArray *)currentVisibleQueue {
    return self.unitQueue;
}

- (NSString *)imagePathForUserInput:(UserInput)userInput {
    switch (userInput) {
        case UserInputAttack:
            return @""; //@"attack.png";
            break;
        case UserInputDefend:
            return @""; //@"defend.png";
            break;
        default:
            return nil;
            break;
    }
}


@end

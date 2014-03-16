//
//  MonsterData.m
//  SequenceGame
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "MonsterData.h"
#import "GameConstants.h"

@implementation MonsterData

- (id)initWithUnitType:(UnitType)unitType {
    self = [super init];
    if (self) {
        [self setupWithUnitType:unitType];
    }
    return self;
}

- (void)setupWithUnitType:(UnitType)unitType {
    self.unitType = unitType;
    
    switch (unitType) {
        case UnitTypeArrow:
            self.hp = 1;
            break;
        case UnitTypeMonster:
            self.hp = 1;
            break;
        case UnitTypeBoss:
            self.hp = 20;
            break;
        default:
            break;
    }
}

+ (NSString *)imagePathFor:(UnitType)unitType {
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

@end

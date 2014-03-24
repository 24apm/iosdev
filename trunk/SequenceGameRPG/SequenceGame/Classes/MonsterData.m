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
        self.unitType = unitType;
        [self setupWithUnitType:unitType];
    }
    return self;
}

- (void)setupWithUnitType:(UnitType)unitType {
    self.validUserInputs = [NSMutableArray array];
    switch (unitType) {
        case UnitTypeArrow:
            self.hp = 1;
            self.imagePath = IMAGE_ARROW;
            [self.validUserInputs addObject:[NSNumber numberWithInteger:UserInputDefend]];
            break;
        case UnitTypeMonster:
            self.hp = 1;
            self.imagePath = IMAGE_MONSTER;
            [self.validUserInputs addObject:[NSNumber numberWithInteger:UserInputAttack]];
            break;
        case UnitTypeEnergy:
            self.hp = 1;
            self.imagePath = IMAGE_ENERGY;
            [self.validUserInputs addObject:[NSNumber numberWithInteger:UserInputAttack]];
            [self.validUserInputs addObject:[NSNumber numberWithInteger:UserInputDefend]];
            break;
        case UnitTypeMaterialShield:
            self.hp = 1;
            self.imagePath = IMAGE_MATERIAL_SHIELD;
            [self.validUserInputs addObject:[NSNumber numberWithInteger:UserInputAttack]];
            [self.validUserInputs addObject:[NSNumber numberWithInteger:UserInputDefend]];
            break;
        case UnitTypeMaterialWeapon:
            self.hp = 1;
            self.imagePath = IMAGE_MATERIAL_WEAPON;
            [self.validUserInputs addObject:[NSNumber numberWithInteger:UserInputAttack]];
            [self.validUserInputs addObject:[NSNumber numberWithInteger:UserInputDefend]];
            break;
        case UnitTypeBoss:
            self.hp = 20;
            self.imagePath = IMAGE_BOSS;
            [self.validUserInputs addObject:[NSNumber numberWithInteger:UserInputAttack]];
            break;
        default:
            break;
    }
}

- (BOOL)isValidUserInput:(UserInput)userInput {
    for (NSNumber *input in self.validUserInputs) {
        if ([input integerValue] == userInput) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)imageForVictory:(UnitType)unitType {
    NSString *image;
    switch (unitType) {
        case UnitTypeArrow:
            image = IMAGE_ARROW;
            break;
        case UnitTypeMonster:
            image = IMAGE_MONSTER;
            break;
        case UnitTypeBoss:
            image = IMAGE_BOSS;
            break;
        default:
            break;
    }
    return image;
}

+ (NSString *)imageForDefeated:(UnitType)unitType {
    NSString *image;
    switch (unitType) {
        case UnitTypeArrow:
            image = @"femalelose.png";
            break;
        case UnitTypeMonster:
            image =@"malelose.png";
            break;
        case UnitTypeBoss:
            image = IMAGE_BOSS;
            break;
        default:
            break;
    }
    return image;
}



@end

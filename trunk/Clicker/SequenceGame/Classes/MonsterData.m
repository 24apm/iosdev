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
    switch (unitType) {
        case UnitTypeArrow:
            self.hp = 1;
            self.imagePath = IMAGE_ARROW;
            break;
        case UnitTypeMonster:
            self.hp = 1;
            self.imagePath = IMAGE_MONSTER;
            break;
        case UnitTypeBoss:
            self.hp = 20;
            self.imagePath = IMAGE_BOSS;
            break;
        default:
            break;
    }
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

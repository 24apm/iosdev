//
//  MonsterData.h
//  SequenceGame
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewController.h"

typedef enum {
    UnitTypeEmpty,
    UnitTypeArrow,
    UnitTypeMonster,
    UnitTypeEnergy,
    UnitTypeMaterialWeapon,
    UnitTypeMaterialShield,
    UnitTypeBoss
} UnitType;

@interface MonsterData : NSObject

@property (nonatomic) UnitType          unitType;
@property (nonatomic, copy) NSString    *imagePath;
@property (nonatomic) int               hp;
@property (nonatomic, strong) NSMutableArray *validUserInputs;

- (id)initWithUnitType:(UnitType)unitType;
- (BOOL)isValidUserInput:(UserInput)userInput;

+ (NSString *)imageForVictory:(UnitType)unitType;
+ (NSString *)imageForDefeated:(UnitType)unitType;

@end

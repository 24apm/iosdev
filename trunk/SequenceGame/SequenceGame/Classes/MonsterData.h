//
//  MonsterData.h
//  SequenceGame
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UnitTypeEmpty,
    UnitTypeArrow,
    UnitTypeMonster,
    UnitTypeBoss
} UnitType;

@interface MonsterData : NSObject

@property (nonatomic) UnitType  unitType;
@property (nonatomic) int       hp;

+ (NSString *)imagePathFor:(UnitType)unitType;
- (id)initWithUnitType:(UnitType)unitType;

@end

//
//  LevelUpHelper.h
//  Make It Flappy
//
//  Created by MacCoder on 6/9/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LevelUpTypeBurst,
    LevelUpTypeStamina,
    LevelUpTypeFlappy
} LevelUpType;

@interface LevelUpHelper : NSObject

+ (int)levelExpCheck:(LevelUpType)type currentLevel:(int)level;

@end

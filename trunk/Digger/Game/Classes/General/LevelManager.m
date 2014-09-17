//
//  LevelManager.m
//  Weed
//
//  Created by MacCoder on 7/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "LevelManager.h"
#import "Utils.h"
#import "UserData.h"
#import "GameConstants.h"

@interface LevelManager()

@end

@implementation LevelManager

+ (LevelManager *)instance {
    static LevelManager *instance = nil;
    if (!instance) {
        instance = [[LevelManager alloc] init];
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
}

- (NSArray *)levelDataTypeFor:(int)tiles {
    NSMutableArray *levelDataType = [NSMutableArray array];
    for (int i = 0; i < tiles; i++) {
        [levelDataType addObject:[NSNumber numberWithInt:[Utils randBetweenMinInt:BlockTypeObstacle max:BlockTypePlayer]]];
    }
    return levelDataType;
}


- (NSArray *)levelDataTierFor:(int)tiles {
    NSMutableArray *levelDataTier = [NSMutableArray array];
    for (int i = 0; i < tiles; i++) {
        [levelDataTier addObject:[NSNumber numberWithInt:[Utils randBetweenMinInt:0 max:3]]];
    }
    return levelDataTier;
}
@end

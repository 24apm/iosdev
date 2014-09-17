//
//  LevelManager.h
//  Weed
//
//  Created by MacCoder on 7/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelManager : NSObject

+ (LevelManager *)instance;

- (NSArray *)levelDataTypeFor:(int)tiles;
- (NSArray *)levelDataTierFor:(int)tiles;
@end

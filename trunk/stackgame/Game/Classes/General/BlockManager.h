//
//  BlockManager.h
//  StackGame
//
//  Created by MacCoder on 2/20/15.
//  Copyright (c) 2015 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockManager : NSObject

typedef enum {
    BlockType_Empty,
    BlockType_Orange,
    BlockType_Apple,
    BlockType_Watermelon,
    BlockType_Mango,
    BlockType_Strawberry,
    BlockType_Pear,
    BlockType_Grape,
    BlockType_Banana,
    BlockType_Cherry,
    BlockType_Lemon
} BlockType;

typedef enum {
    BlockStateDropping,
    BlockStateLanded
} BlockState;

+ (UIColor *)colorForBlockType:(BlockType)type;

@end

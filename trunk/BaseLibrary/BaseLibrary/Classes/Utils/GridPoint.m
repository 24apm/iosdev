//
//  GridPoint.m
//  BaseLibrary
//
//  Created by MacCoder on 9/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GridPoint.h"

@implementation GridPoint

+ (GridPoint *)gridPointWithRow:(NSUInteger)row col:(NSUInteger)col {
    return [[GridPoint alloc] initWithRow:row col:col];
}

- (GridPoint *)initWithRow:(NSUInteger)row col:(NSUInteger)col
{
    self = [super init];
    if (self) {
        self.row = row;
        self.col = col;
    }
    return self;
}

@end

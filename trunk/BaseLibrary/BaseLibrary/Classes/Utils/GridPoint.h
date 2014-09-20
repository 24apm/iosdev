//
//  GridPoint.h
//  BaseLibrary
//
//  Created by MacCoder on 9/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridPoint : NSObject

@property (nonatomic) NSUInteger col;
@property (nonatomic) NSUInteger row;

+ (GridPoint *)gridPointWithRow:(NSUInteger)row col:(NSUInteger)col;

@end

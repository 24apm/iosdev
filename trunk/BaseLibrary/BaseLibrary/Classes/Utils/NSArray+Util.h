//
//  NSArray+Util.h
//  Base
//
//  Created by MacCoder on 2/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Util)

- (id) randomObject;

@end

@interface NSMutableArray (Util)

- (void) shuffle;

@end

@interface NSMutableArray (QueueAdditions)

- (id) dequeue;
- (void) enqueue:(id)obj;

@end
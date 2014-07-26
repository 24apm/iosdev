//
//  NSArray+Util.m
//  Base
//
//  Created by MacCoder on 2/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "NSArray+Util.h"
#import "Utils.h"
@interface NSArray()

@end

@implementation NSArray (Util)

- (id) randomObject {
    if ([self count] == 0) {
        return nil;
    }
    return [self objectAtIndex: arc4random() % [self count]];
}

@end

@interface NSMutableArray()

@end

@implementation NSMutableArray (Util)

- (void)shuffle {
    if ([self count] == 0) {
        return;
    }
    int totalNumber = [self count];
    for (int i = 0; i < totalNumber; i++) {
        int index = [Utils randBetweenMinInt:0 max:totalNumber - 1];
        id oldElement = [self objectAtIndex:i];
        id newElement = [self objectAtIndex:(index)];
        [self replaceObjectAtIndex:i withObject:newElement];
        [self replaceObjectAtIndex:index withObject:oldElement];
    }
}

@end

@implementation NSMutableArray (QueueAdditions)
// Queues are first-in-first-out, so we remove objects from the head
- (id) dequeue {
    // if ([self count] == 0) return nil; // to avoid raising exception (Quinn)
    id headObject = [self objectAtIndex:0];
    if (headObject != nil) {
        [self removeObjectAtIndex:0];
    }
    return headObject;
}

// Add to the tail of the queue (no one likes it when people cut in line!)
- (void) enqueue:(id)anObject {
    [self addObject:anObject];
    //this method automatically adds to the end of the array
}
@end

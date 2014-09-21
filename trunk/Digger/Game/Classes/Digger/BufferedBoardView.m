//
//  BufferedBoardView.m
//  Digger
//
//  Created by MacCoder on 9/21/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BufferedBoardView.h"
#import "BoardManager.h"
#import "LevelManager.h"

@interface BufferedBoardView()

@property (nonatomic) NSInteger nextBufferRowIndex;

@end

@implementation BufferedBoardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.slots = [NSMutableArray array];
    }
    return self;
}

- (void)reset {
    self.nextBufferRowIndex = 0;
    [self generateBufferMapForView];
}

- (void)generateSlots {
    for (int r = 0; r < NUM_ROW; r++) {
        for (int c = 0; c < NUM_COL; c++) {
            SlotView *slotView = [[SlotView alloc] init];
            slotView.frame = CGRectIntegral(CGRectMake(c * [BoardManager instance].slotSize.width,
                                                       r * [BoardManager instance].slotSize.height,
                                                       [BoardManager instance].slotSize.width,
                                                       [BoardManager instance].slotSize.height));
            [self.slots addObject:slotView];
            [self addSubview:slotView];
        }
    }
}

- (void)generateNextRow {
    NSArray *nextBufferedRow = [self slotsAtRow:self.nextBufferRowIndex];
    NSUInteger index = self.nextBufferRowIndex * NUM_COL;
    
    for (SlotView *slot in nextBufferedRow) {
        NSUInteger currentType = [[self.nextBufferedTypes objectAtIndex:index]intValue];
        NSUInteger currentTier = [[self.nextBufferedTiers objectAtIndex:index]intValue];
        index++;
        BlockView *blockView = [[BoardManager instance] blockViewForType:currentType];
        [blockView setupWithTier:currentTier];
        [[BoardManager instance] moveBlock:blockView toSlot:slot];
    }
    
    self.nextBufferRowIndex++;
}

- (void)generateBlocks {
    
    NSArray *currentLevelTypes = [[LevelManager instance] levelDataTypeFor:self.slots.count];
    NSArray *currentLevelTiers = [[LevelManager instance] levelDataTierFor:self.slots.count];
    NSUInteger index = 0;
    
    for (SlotView *slot in self.slots) {
        NSUInteger currentType = [[currentLevelTypes objectAtIndex:index]intValue];
        NSUInteger currentTier = [[currentLevelTiers objectAtIndex:index]intValue];
        index++;
        BlockView *blockView = [[BoardManager instance] blockViewForType:currentType];
        [blockView setupWithTier:currentTier];
        [[BoardManager instance] moveBlock:blockView toSlot:slot];
    }
}

- (NSArray *)slotsAtRow:(NSUInteger)r {
    return [self.slots subarrayWithRange:NSMakeRange(r * NUM_COL, NUM_COL)];
}

- (void)generateBufferMapForView {
    self.nextBufferedTypes = [[LevelManager instance] levelDataTypeFor:self.slots.count];
    self.nextBufferedTiers = [[LevelManager instance] levelDataTierFor:self.slots.count];
}

- (BOOL)canGenerateNextRow {
    return self.nextBufferRowIndex < self.slots.count / NUM_COL;
}

@end

//
//  BoardView.m
//  2048
//
//  Created by MacCoder on 4/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BoardView.h"
#import "TileView.h"
#import "SlotView.h"
#import "Utils.h"

#define BOARD_ROWS 5
#define BOARD_COLS 5

@interface BoardView()

@property (nonatomic, retain) NSMutableArray *slots;

@end

@implementation BoardView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupBoard];
        [self layoutSlots];
        
        for (int i = 0 ; i < 24; i++) {
            [self generateRandomTile];
        }

    }
    return self;
}

- (void)setupBoard {
    SlotView *slot = nil;
    
    self.slots = [NSMutableArray array];
    
    for (int y = 0; y < BOARD_ROWS; y++) {
        for (int x = 0; x < BOARD_COLS; x++) {
            slot = [[SlotView alloc] init];
            [self.slots addObject:slot];
            [self addSubview:slot];
        }
    }
}

- (void)layoutSlots {
    SlotView *slot = nil;

    int space = 5;
    
    for (int row = 0; row < BOARD_ROWS; row++) {
        for (int col = 0; col < BOARD_COLS; col++) {
            slot = [self slotAt:row :col];
            slot.center = CGPointMake(col * (slot.width + space) + slot.center.x,
                                      row * (slot.height + space) + slot.center.y);
        }
    }
}

- (void)generateRandomTile {
    SlotView *slot = [[self emptySlotArray] randomObject];
    [self generateTileForSlot:slot];
}

- (NSMutableArray *)emptySlotArray {
    NSMutableArray *emptyArray = [NSMutableArray array];
    for (SlotView *slot in self.slots) {
        if (!slot.tileView) {
            [emptyArray addObject:slot];
        }
    }
    return emptyArray;
}

- (void)generateTileForSlot:(SlotView *)slot {
    TileView *tile = [[TileView alloc] init];
    slot.tileView = tile;
    [self addSubview:tile];
    tile.center = slot.center;
}


- (SlotView *)slotAt:(int)row :(int)col {
    return [self.slots objectAtIndex:col + row * BOARD_COLS];
}

@end

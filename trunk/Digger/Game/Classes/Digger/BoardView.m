//
//  BoardView.m
//  Digger
//
//  Created by MacCoder on 9/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BoardView.h"
#import "SlotView.h"
#import "ObstacleView.h"
#import "PlayerView.h"
#import "TreasureView.h"
#import "BoardView.h"
#import "LevelManager.h"
#import "GameConstants.h"
#import "NSArray+Util.h"
#import "BoardManager.h"
#import "GridPoint.h"
#import "PowerView.h"
#import "BufferedBoardView.h"


@interface BoardView()

@property (nonatomic) CGSize slotSize;

@property (strong, nonatomic) BufferedBoardView *view1;
@property (strong, nonatomic) BufferedBoardView *view2;
@property (strong, nonatomic) NSMutableArray *viewsSlotsCount;
@property (nonatomic) CGFloat view2Start;


@property (strong, nonatomic) BufferedBoardView *currentBufferedView;

@end

@implementation BoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

- (void)setup {
    [[BoardManager instance] setupWithBoard:self];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    self.scrollView.bounces = NO;
    self.scrollView.minimumZoomScale = 0.1;
    
    self.scrollView.size = self.size;
    
    self.slotSize = [BoardManager instance].slotSize;
    
    self.viewsSlotsCount = [NSMutableArray array];
    
    self.view1 = [[BufferedBoardView alloc] init];
    self.view1.frame = CGRectMake(0,
                                  0,
                                  self.width,
                                  self.slotSize.height * NUM_ROW);
    
    self.view2 = [[BufferedBoardView alloc] init];
    self.view2.frame = CGRectMake(0,
                                  self.view1.height,
                                  self.width,
                                  self.slotSize.height * NUM_ROW);
    
    [self.scrollView addSubview:self.view1];
    [self.scrollView addSubview:self.view2];
    
    
    [self.view1 generateSlots];
    [self.view2 generateSlots];
    
    [BoardManager instance].slots = [self.view1.slots arrayByAddingObjectsFromArray:self.view2.slots];
    
    [self newGame];
    
    self.scrollView.contentSize = CGSizeMake(self.width, self.view1.height);
    self.view2Start = [BoardManager instance].slots.count/NUM_COL * self.slotSize.height/2;
}

- (void)newGame {
    self.view1.frame = CGRectMake(0,
                                  0,
                                  self.width,
                                  self.slotSize.height * NUM_ROW);
    self.view2.frame = CGRectMake(0,
                                  self.view1.height + 20,
                                  self.width,
                                  self.slotSize.height * NUM_ROW);
    
    [self.view1 generateBlocks];
//    [self.view2 generateBlocks];
    [self generatePlayer];
    self.currentBufferedView = self.view2;
    [self.currentBufferedView reset];
    
    self.depth = 0;
}

- (void)shiftUp {
    [UIView animateWithDuration:0.3f delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
        self.view1.y -= self.slotSize.height;
        self.view2.y -= self.slotSize.height;
    } completion:^(BOOL completed) {
        
    }];    
}

- (void)generateBoardIfNecessary {
    self.depth++;
    
    NSInteger numRows = [BoardManager instance].slots.count / NUM_COL;
    
    NSInteger buffer = 1;
    if (self.depth % numRows == numRows / 2 + buffer) {
        self.currentBufferedView = self.view1;
        [self.currentBufferedView reset];
        self.view1.y = self.view2.y + self.view2.height;

    }
    if (self.depth % numRows == 0 + buffer) {
        self.currentBufferedView = self.view2;
        [self.currentBufferedView reset];
        self.view2.y = self.view1.y + self.view1.height;

    }
    [self.currentBufferedView generateNextRow];
}

- (void)generatePlayer {
    self.playerView = [[PlayerView alloc] init];
    NSArray *slots = [[BoardManager instance] slotsAtRow:0];
    SlotView *startingSlot = [slots randomObject];
    [[BoardManager instance] movePlayerBlock:startingSlot];
}

- (BOOL)isNeighboringSlot:(SlotView *)slotView {
    GridPoint *playerPoint = [[BoardManager instance] pointForSlot:self.playerView.slotView];
    
    if (playerPoint.col > 0) {
        
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row column:playerPoint.col-1];
        if (slotView == openSlot) {
            return YES;
        }
    }
    if (playerPoint.col < NUM_COL-1) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row column:playerPoint.col+1];
        if (slotView == openSlot) {
            return YES;
        }
    }
    if (playerPoint.row >= [BoardManager instance].slots.count/NUM_COL-1 ) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:0 column:playerPoint.col];
        if (slotView == openSlot) {
            return YES;
        }
    } else {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row+1 column:playerPoint.col];
        if (slotView == openSlot) {
            return YES;
        }
    }
    return NO;
}

- (void)refreshBoardLocalLock {
    
    GridPoint *playerPoint = [[BoardManager instance] pointForSlot:self.playerView.slotView];
    
    if (playerPoint.col > 0) {
        
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row column:playerPoint.col-1];
        openSlot.blockView.blocker.hidden = NO;
    }
    if (playerPoint.col < NUM_COL-1) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row column:playerPoint.col+1];
        openSlot.blockView.blocker.hidden = NO;
    }
    if (playerPoint.row >= [BoardManager instance].slots.count/NUM_COL-1 ) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:0 column:playerPoint.col];
        openSlot.blockView.blocker.hidden = NO;
    } else {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row+1 column:playerPoint.col];
        openSlot.blockView.blocker.hidden = NO;
    }
}

- (void)refreshBoardLocalOpen {
    
    GridPoint *playerPoint = [[BoardManager instance] pointForSlot:self.playerView.slotView];
    
    if (playerPoint.col > 0) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row column:playerPoint.col-1];
        openSlot.blockView.blocker.hidden = YES;
    }
    if (playerPoint.col < NUM_COL-1) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row column:playerPoint.col+1];
        openSlot.blockView.blocker.hidden = YES;
    }
    if (playerPoint.row >= [BoardManager instance].slots.count/NUM_COL-1 ) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:0 column:playerPoint.col];
        openSlot.blockView.blocker.hidden = YES;
    } else {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row+1 column:playerPoint.col];
        openSlot.blockView.blocker.hidden = YES;
    }
    
}

- (void)refreshBoard {
    for (SlotView *slot in [BoardManager instance].slots) {
        slot.blockView.blocker.hidden = NO;
    }
}

@end

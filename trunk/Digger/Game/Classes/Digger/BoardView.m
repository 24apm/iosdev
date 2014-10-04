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
@property (strong, nonatomic) NSMutableArray *queueStackArray;
@property (strong, nonatomic) NSMutableSet *queueSet;


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
    
    self.queueSet = [NSMutableSet set];
    self.queueStackArray = [NSMutableArray array];
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
    
    self.depth = 0;
    [self.view1 generateBlocks];
    //    [self.view2 generateBlocks];
    [self generatePlayer];
    self.currentBufferedView = self.view2;
    [self.currentBufferedView reset];
}

- (void)newGameWaypointTo:(NSUInteger)depth {
    self.view1.frame = CGRectMake(0,
                                  0,
                                  self.width,
                                  self.slotSize.height * NUM_ROW);
    self.view2.frame = CGRectMake(0,
                                  self.view1.height + 20,
                                  self.width,
                                  self.slotSize.height * NUM_ROW);
    
    self.depth = 0;
    [self.view1 generateBlocks];
    //    [self.view2 generateBlocks];
    [self generatePlayer];
    self.currentBufferedView = self.view2;
    [self.currentBufferedView reset];
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

- (void)hideBoardLocalEmptyEffect:(BOOL)state {
    
    GridPoint *playerPoint = [[BoardManager instance] pointForSlot:self.playerView.slotView];
    
    for (int i = 0; i < NUM_COL; i++) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row column:i];
        if (openSlot.blockView == nil) {
            openSlot.glowEffectView.hidden = state;
            if (!state) {
                [self fadeInAndOut:openSlot.glowEffectView];
            } else {
                [openSlot.glowEffectView.layer removeAllAnimations];
            }
        }
    }
}

- (void)fadeInAndOut:(UIView *)view {
    CABasicAnimation *fadeInAndOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAndOut.fromValue = [NSNumber numberWithFloat:0.5f];
    fadeInAndOut.toValue = [NSNumber numberWithFloat:1.f];
    fadeInAndOut.autoreverses = YES;
    fadeInAndOut.duration = 1.8f;
    fadeInAndOut.repeatCount = HUGE_VAL;
    [view.layer addAnimation:fadeInAndOut forKey:@"fadeInAndOut"];
}

- (void)refreshBoardLocalOpen:(BOOL)state {
    
    GridPoint *playerPoint = [[BoardManager instance] pointForSlot:self.playerView.slotView];
    
    if (playerPoint.col > 0) {
        
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row column:playerPoint.col-1];
        [openSlot.blockView showBlockerView:!state];
    }
    
    if (playerPoint.col < NUM_COL-1) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row column:playerPoint.col+1];
        [openSlot.blockView showBlockerView:!state];
    }
    
    if (playerPoint.row >= [BoardManager instance].slots.count/NUM_COL-1 ) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:0 column:playerPoint.col];
        [openSlot.blockView showBlockerView:!state];
    } else {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row+1 column:playerPoint.col];
        [openSlot.blockView showBlockerView:!state];
    }
}

- (void)refreshBoardLocalOpen {
    
    GridPoint *playerPoint = [[BoardManager instance] pointForSlot:self.playerView.slotView];
    
    if (playerPoint.col > 0) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row column:playerPoint.col-1];
        [openSlot.blockView showBlockerView:NO];
    }
    if (playerPoint.col < NUM_COL-1) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row column:playerPoint.col+1];
        [openSlot.blockView showBlockerView:NO];
    }
    if (playerPoint.row >= [BoardManager instance].slots.count/NUM_COL-1 ) {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:0 column:playerPoint.col];
        [openSlot.blockView showBlockerView:NO];
    } else {
        SlotView *openSlot = [[BoardManager instance] slotAtRow:playerPoint.row+1 column:playerPoint.col];
        [openSlot.blockView showBlockerView:NO];
    }
    
}

- (void)refreshBoard {
    for (SlotView *slot in [BoardManager instance].slots) {
        [slot.blockView showBlockerView:YES];
        
    }
}

- (NSUInteger)currentDepth {
    return self.depth;
}

- (void)findBombBlockOnSlot:(SlotView *)slot {
    SlotView *currentSlot = slot;
    BlockType currentType = currentSlot.blockView.type;
    NSUInteger currentTier = currentSlot.blockView.tier;
    [self.queueSet addObject:slot];
   // [self.queueStackArray addObject:currentSlot];
    GridPoint *slotPoint = [[BoardManager instance] pointForSlot:slot];
    SlotView *upSlot = [self checkSlotUp:slotPoint];
    SlotView *downSlot = [self checkSlotDown:slotPoint];
    SlotView *leftSlot = [self checkSlotLeft:slotPoint];
    SlotView *rightSlot = [self checkSlotRight:slotPoint];
    
    if (currentType == upSlot.blockView.type && currentTier == upSlot.blockView.tier) {
        if (![self.queueSet containsObject:upSlot] && upSlot != nil) {
            [self findBombBlockOnSlot:upSlot];
        }
    }
    if (currentType == downSlot.blockView.type && currentTier == downSlot.blockView.tier) {
        if (![self.queueSet containsObject:downSlot] && downSlot != nil) {
            [self findBombBlockOnSlot:downSlot];
        }
    }
    if (currentType == leftSlot.blockView.type && leftSlot != nil && currentTier == leftSlot.blockView.tier) {
        if (![self.queueSet containsObject:leftSlot]) {
            [self findBombBlockOnSlot:leftSlot];
        }
    }
    if (currentType == rightSlot.blockView.type && rightSlot != nil && currentTier == rightSlot.blockView.tier) {
        if (![self.queueSet containsObject:rightSlot]) {
            [self findBombBlockOnSlot:rightSlot];
        }
    }
}

- (void)cleanBombSet {
    for (SlotView *view in self.queueSet) {
        view.blockView.imageView.image = [UIImage imageNamed:@"cloud"];
    }
    self.queueSet = [NSMutableSet set];
}

- (SlotView *)checkSlotUp:(GridPoint *)slotPoint {
    SlotView *newSlot;
    if (slotPoint.row > 0) {
        newSlot = [[BoardManager instance] slotAtRow:slotPoint.row-1 column:slotPoint.col];
    }
    return newSlot;
}

- (SlotView *)checkSlotDown:(GridPoint *)slotPoint {
    SlotView *newSlot;
    if (slotPoint.row < NUM_ROW * 2-1) {
        newSlot = [[BoardManager instance] slotAtRow:slotPoint.row+1 column:slotPoint.col];
    }
    return newSlot;
}

- (SlotView *)checkSlotLeft:(GridPoint *)slotPoint {
    SlotView *newSlot;
    if (slotPoint.col > 0) {
        newSlot = [[BoardManager instance] slotAtRow:slotPoint.row column:slotPoint.col-1];
    }
    return newSlot;
}

- (SlotView *)checkSlotRight:(GridPoint *)slotPoint {
    SlotView *newSlot;
    if (slotPoint.col < NUM_COL-1) {
        newSlot = [[BoardManager instance] slotAtRow:slotPoint.row column:slotPoint.col+1];
    }
    return newSlot;
}



@end

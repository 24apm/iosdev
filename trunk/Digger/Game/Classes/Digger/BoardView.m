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



@interface BoardView()

@property (nonatomic) CGSize slotSize;

@property (strong, nonatomic) UIView *view1;
@property (strong, nonatomic) UIView *view2;
@property (strong, nonatomic) NSMutableArray *viewsSlotsCount;
@property (nonatomic) CGFloat view2Start;

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
    
    self.view1 = [[UIView alloc] init];
    self.view1.frame = CGRectMake(0,
                                  0,
                                  self.width,
                                  self.slotSize.height * NUM_ROW);
    self.view1.backgroundColor = [UIColor redColor];
    
    self.view2 = [[UIView alloc] init];
    self.view2.frame = CGRectMake(0,
                                  self.view1.height,
                                  self.width,
                                  self.slotSize.height * NUM_ROW);
    
    self.view2.backgroundColor = [UIColor blueColor];
    
    [self.scrollView addSubview:self.view1];
    [self.scrollView addSubview:self.view2];
    
    [self generateSlots:self.view1];
    [self generateSlots:self.view2];
    
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
                                  self.view1.height,
                                  self.width,
                                  self.slotSize.height * NUM_ROW);
    [self generateBlocks];
    [self generatePlayer];
}

- (void)shiftUp {
    self.view1.y -= self.slotSize.height;
    self.view2.y -= self.slotSize.height;
    
}

- (void)generateBoardIfNecessary {
    CGFloat boardSize = self.view2Start - self.slotSize.height;
    CGFloat boardSizeCheckLimit = -self.view2Start - self.slotSize.height + 1;
    if (self.view1.y <= boardSizeCheckLimit) {
        self.view1.y = boardSize;
        [self generateBlocksForView:self.view1];
    }
    if (self.view2.y <= boardSizeCheckLimit) {
        self.view2.y = boardSize;
        [self generateBlocksForView:self.view2];
    }
}

- (void)generatePlayer {
    self.playerView = [[PlayerView alloc] init];
    NSArray *slots = [[BoardManager instance] slotsAtRow:0];
    SlotView *startingSlot = [slots randomObject];
    [[BoardManager instance] movePlayerBlock:startingSlot];
}

- (void)generateBlocks {
    
    NSArray *currentLevelTypes = [[LevelManager instance] levelDataTypeFor:[BoardManager instance].slots.count];
    NSArray *currentLevelTiers = [[LevelManager instance] levelDataTierFor:[BoardManager instance].slots.count];
    NSUInteger index = 0;
    
    for (SlotView *slot in [BoardManager instance].slots) {
        NSUInteger currentType = [[currentLevelTypes objectAtIndex:index]intValue];
        NSUInteger currentTier = [[currentLevelTiers objectAtIndex:index]intValue];
        index++;
        BlockView *blockView = [[BoardManager instance] blockViewForType:currentType];
        [blockView setupWithTier:currentTier];
        [[BoardManager instance] moveBlock:blockView toSlot:slot];
    }
}
- (void)generateBlocksForView:(UIView *)view {
    
    NSArray *currentLevelTypes = [[LevelManager instance] levelDataTypeFor:view.subviews.count];
    NSArray *currentLevelTiers = [[LevelManager instance] levelDataTierFor:view.subviews.count];
    NSUInteger index = 0;
    
    for (SlotView *slot in view.subviews) {
        NSUInteger currentType = [[currentLevelTypes objectAtIndex:index]intValue];
        NSUInteger currentTier = [[currentLevelTiers objectAtIndex:index]intValue];
        index++;
        
        
        BlockView *blockView = [[BoardManager instance] blockViewForType:currentType];
        [blockView setupWithTier:currentTier];
        [[BoardManager instance] moveBlock:blockView toSlot:slot];
    }
}

- (void)generateSlots:(UIView *)view {
    NSUInteger slotsCount = 0;
    for (int r = 0; r < NUM_ROW; r++) {
        for (int c = 0; c < NUM_COL; c++) {
            SlotView *slotView = [[SlotView alloc] init];
            slotView.frame = CGRectIntegral(CGRectMake(c * self.slotSize.width,
                                                       r * self.slotSize.height,
                                                       self.slotSize.width,
                                                       self.slotSize.height));
            [[BoardManager instance].slots addObject:slotView];
            [view addSubview:slotView];
        }
    }
    [self.viewsSlotsCount addObject:[NSNumber numberWithInteger:slotsCount - 1]];
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

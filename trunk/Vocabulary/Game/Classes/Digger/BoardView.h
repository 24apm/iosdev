//
//  BoardView.h
//  Digger
//
//  Created by MacCoder on 9/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"

@class SlotView;

@interface BoardView : UIView

- (void)setup;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) PlayerView *playerView;
@property (nonatomic) NSInteger depth;

- (void)refreshBoard;
- (void)refreshBoardLocalOpen:(BOOL)state;
- (void)hideBoardLocalEmptyEffect:(BOOL)state;
- (void)shiftUp;
- (void)generateBoardIfNecessary;
- (void)newGame;
- (BOOL)isNeighboringSlot:(SlotView *)slotView;
- (NSUInteger) currentDepth;
- (void)findBombBlockOnSlot:(SlotView *)slot;
- (void)cleanBombSet;
- (void)newGameWaypointTo:(NSUInteger)depth;

@end
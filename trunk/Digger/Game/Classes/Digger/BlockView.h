//
//  BlockView.h
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "GameConstants.h"

#define BLOCK_PRESSED_NOTIFICATION @"BLOCK_PRESSED_NOTIFICATION"

@class SlotView;
@class BlockView;
@class BoardView;

@interface BlockView : XibView

@property (strong, nonatomic) SlotView *slotView;

@property (strong, nonatomic) IBOutlet UIView *block;
@property (strong, nonatomic) IBOutlet UIView *blocker;
@property (nonatomic) BlockType type;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) NSUInteger tier;
@property (nonatomic) NSUInteger level;
@property (strong, nonatomic) BoardView *boardView;

- (instancetype)initWithBoardView:(BoardView *)boardView;
- (BOOL)doAction:(SlotView *)slotView;
- (void)setupWithTier:(NSUInteger)tier;
- (void)showBlockerView:(BOOL)flag;


@end

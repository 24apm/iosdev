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

@interface BlockView : XibView

@property (strong, nonatomic) SlotView *slotView;

@property (strong, nonatomic) IBOutlet UIView *block;
@property (strong, nonatomic) IBOutlet UIView *blocker;
@property (nonatomic) BlockType type;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (void)setupWithTier:(NSUInteger)tier;

@end

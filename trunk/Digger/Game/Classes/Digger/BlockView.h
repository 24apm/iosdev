//
//  BlockView.h
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

#define BLOCK_PRESSED_NOTIFICATION @"BLOCK_PRESSED_NOTIFICATION"

@class TileView;

@interface BlockView : XibView

@property (strong, nonatomic) TileView *tileView;

@property (strong, nonatomic) IBOutlet UIView *block;
@property (strong, nonatomic) IBOutlet UIView *blocker;

- (void)setupWithTier:(int)tier;

@end

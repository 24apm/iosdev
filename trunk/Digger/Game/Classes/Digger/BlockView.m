//
//  BlockView.m
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BlockView.h"
#import "BoardManager.h"

@interface BlockView()

@end

@implementation BlockView

- (instancetype)initWithBoardView:(BoardView *)boardView {
    self = [super init];
    if (self) {
        self.boardView = boardView;
    }
    return self;
}

- (void)setupWithTier:(NSUInteger)tier
{
    self.tier = tier;
}

- (IBAction)buttonPressed:(id)sender {
}

- (void)showBlockerView:(BOOL)flag {
    self.blocker.hidden = !flag;
}

- (BOOL)doAction:(SlotView *)slotView {
    // get overridden
    return YES;
}

@end

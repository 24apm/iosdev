//
//  SlotView.h
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

#define SLOTS_PRESSED_NOTIFICATION @"SLOTS_PRESSED_NOTIFICATION"

@class BlockView;

@interface SlotView : XibView

@property (strong, nonatomic) BlockView *blockView;

@end

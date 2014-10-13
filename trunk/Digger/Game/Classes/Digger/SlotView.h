//
//  SlotView.h
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "BlockView.h"

#define SLOTS_PRESSED_NOTIFICATION @"SLOTS_PRESSED_NOTIFICATION"

@interface SlotView : XibView

@property (strong, nonatomic) BlockView *blockView;
@property (strong, nonatomic) IBOutlet UIView *glowEffectView;

@end

//
//  PowerView.m
//  Digger
//
//  Created by MacCoder on 9/20/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PowerView.h"
#import "CAEmitterHelperLayer.h"
#import "UserData.h"
#import "GameConstants.h"
#import "CAEmitterHelperLayer.h"
#import "BoardManager.h"
#import "Utils.h"


@implementation PowerView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)doAction:(SlotView *)slotView {
    [super doAction:slotView];
    
    NSInteger staminaBarIncrease = 2.f * self.hp;
    [[UserData instance] incrementStamina:staminaBarIncrease];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ANIMATE_FOR_BLOCK_QUEUE object:slotView.blockView.imageView.image];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ANIMATE_POWER object:self];
    return YES;
}

- (void)setupWithTier:(NSUInteger)tier {
    [super setupWithTier:tier];
    self.hp = tier;
    switch (tier) {
        case 0:
            self.block.backgroundColor = [UIColor magentaColor];
            break;
        case 1:
            self.block.backgroundColor = [UIColor magentaColor];
            break;
        case 2:
            self.block.backgroundColor = [UIColor magentaColor];
            break;
        case 3:
            self.block.backgroundColor = [UIColor magentaColor];
            break;
        case 4:
            self.block.backgroundColor = [UIColor magentaColor];
            break;
        case 5:
            self.block.backgroundColor = [UIColor magentaColor];
            break;
        case 6:
            self.block.backgroundColor = [UIColor magentaColor];
            break;
        case 7:
            self.block.backgroundColor = [UIColor magentaColor];
            break;
        case 8:
            self.block.backgroundColor = [UIColor magentaColor];
            break;
        case 9:
            self.block.backgroundColor = [UIColor magentaColor];
            break;
            
        default:
            break;
    }
}

@end

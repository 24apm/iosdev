//
//  TreasureView.m
//  Digger
//
//  Created by MacCoder on 9/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "TreasureView.h"
#import "UserData.h"
#import "GameConstants.h"
#import "CAEmitterHelperLayer.h"
#import "BoardManager.h"
#import "Utils.h"

@implementation TreasureView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)doAction:(SlotView *)slotView {
    [super doAction:slotView];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ANIMATE_FOR_BLOCK_QUEUE object:slotView.blockView.imageView.image];
    
    [self pickingUpTreasure:slotView];
    NSInteger staminaCost = 1;
    [[UserData instance]decrementStamina:staminaCost];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_REFRESH_STAMINA object:[NSNumber numberWithInteger:staminaCost]];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ANIMATE_TREASURE object:self];
    return YES;
}

- (void)pickingUpTreasure:(SlotView *)slot {
    NSInteger itemTier = slot.blockView.tier;
    if ([[UserData instance] isKnapsackFull]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_KNAPSACK_FULL object:[NSNumber numberWithInteger:itemTier]];
    } else {
        [[UserData instance] addKnapsackWith:itemTier];
    }
}

- (void)setupWithTier:(NSUInteger)tier {
    self.tier = tier;
    TreasureData *data = [[TreasureData alloc] init];
    data = [data setupItemWithRank:self.tier];
    self.imageView.image = [UIImage imageNamed:data.icon];
    switch (tier) {
        case 0:
            self.block.backgroundColor = [UIColor brownColor];
            break;
        case 1:
            self.block.backgroundColor = [UIColor brownColor];
            break;
        case 2:
            self.block.backgroundColor = [UIColor brownColor];
            break;
        case 3:
            self.block.backgroundColor = [UIColor brownColor];
            break;
        case 4:
            self.block.backgroundColor = [UIColor brownColor];
            break;
        case 5:
            self.block.backgroundColor = [UIColor brownColor];
            break;
        case 6:
            self.block.backgroundColor = [UIColor brownColor];
            break;
        case 7:
            self.block.backgroundColor = [UIColor brownColor];
            break;
        case 8:
            self.block.backgroundColor = [UIColor brownColor];
            break;
        case 9:
            self.block.backgroundColor = [UIColor brownColor];
            break;
            
        default:
            break;
    }
}


@end

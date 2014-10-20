//
//  ObstacleVIew.m
//  Digger
//
//  Created by MacCoder on 9/15/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ObstacleView.h"
#import "UserData.h"
#import "GameConstants.h"
#import "CAEmitterHelperLayer.h"
#import "BoardManager.h"
#import "Utils.h"

@implementation ObstacleView

- (void)setupWithTier:(NSUInteger)tier {
    [super setupWithTier:tier];
    self.hp = tier;
}

- (BOOL)doAction:(SlotView *)slotView {
    [super doAction:slotView];
    
    [[UserData instance] decrementStamina:self.hp];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ANIMATE_FOR_BLOCK_QUEUE object:slotView.blockView.imageView.image];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_REFRESH_STAMINA object:nil];
    return YES;
}

- (void)refresh {
    switch (self.hp) {
        case 0:
            self.block.backgroundColor = [UIColor redColor];
            break;
        case 1:
            self.block.backgroundColor = [UIColor greenColor];
            break;
        case 2:
            self.block.backgroundColor = [UIColor yellowColor];
            break;
        case 3:
            self.block.backgroundColor = [UIColor blueColor];
            break;
        case 4:
            self.block.backgroundColor = [UIColor orangeColor];
            break;
        case 5:
            self.block.backgroundColor = [UIColor purpleColor];
            break;
        case 6:
            self.block.backgroundColor = [UIColor whiteColor];
            break;
        case 7:
            self.block.backgroundColor = [UIColor blackColor];
            break;
        case 8:
            self.block.backgroundColor = [UIColor grayColor];
            break;
        case 9:
            self.block.backgroundColor = [UIColor cyanColor];
            break;
            
        default:
            break;
    }
    self.tierLabel.text = [NSString stringWithFormat:@"%d", self.hp];

}

- (void)setHp:(NSInteger)hp {
    _hp = hp;
    [self refresh];
}

@end

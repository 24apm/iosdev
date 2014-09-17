//
//  ObstacleVIew.m
//  Digger
//
//  Created by MacCoder on 9/15/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ObstacleView.h"

@implementation ObstacleView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)setupWithTier:(int)tier {
    switch (tier) {
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
}

@end

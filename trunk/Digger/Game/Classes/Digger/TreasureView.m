//
//  TreasureView.m
//  Digger
//
//  Created by MacCoder on 9/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "TreasureView.h"

@implementation TreasureView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)setupWithTier:(NSUInteger)tier {
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

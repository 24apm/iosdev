//
//  GameData.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/1/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameData.h"

@implementation GameData
+ (GameData *)instance {
    static GameData *instance = nil;
    if (!instance) {
        instance = [[GameData alloc] init];
    }
    return instance;
}

- (void)resetCost {
    self.shuffleCost = 1;
    self.bomb2Cost = 1;
    self.bomb4Cost = 1;
    
    self.lostGameCost = 0;
}

- (void)shuffleCostUpgrade {
    self.shuffleCost = self.shuffleCost * 2;
}

- (void)bomb2CostUpgrade {
    self.bomb2Cost = self.bomb2Cost * 2;
}

- (void)bomb4CostUpgrade {
    self.bomb4Cost = self.bomb4Cost * 2;
}

- (void)lostGameCostUpgrade {
    if (self.lostGameCost <= 0) {
        self.lostGameCost = self.lostGameCost + 4;
    } else {
    self.lostGameCost = self.lostGameCost * 2;
    }
}

@end

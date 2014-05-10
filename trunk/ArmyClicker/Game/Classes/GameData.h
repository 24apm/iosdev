//
//  GameData.h
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/1/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameData : NSObject

+ (GameData *)instance;

@property (nonatomic) int shuffleCost;
@property (nonatomic) int bomb2Cost;
@property (nonatomic) int bomb4Cost;

@property (nonatomic) int lostGameCost;

- (void)resetCost;
- (void)shuffleCostUpgrade;
- (void)bomb2CostUpgrade;
- (void)bomb4CostUpgrade;

- (void)lostGameCostUpgrade;



@end

//
//  ParallaxForegroundView.h
//  Weed
//
//  Created by MacCoder on 7/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "HouseView.h"

@interface ParallaxForegroundView : XibView

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)setup;
- (void)refreshHouses;
- (HouseView *)firstEmptyHouseUnder:(int)rooms;
- (HouseView *)firstCollectableHouse;
- (HouseView *)newestHouse;

@end

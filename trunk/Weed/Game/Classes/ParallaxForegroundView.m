//
//  ParallaxForegroundView.m
//  Weed
//
//  Created by MacCoder on 7/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ParallaxForegroundView.h"
#import "UserData.h"
#import "NSArray+Util.h"

@interface ParallaxForegroundView()

@property (strong, nonatomic) NSMutableArray *houseViews;
@property (nonatomic) CGRect houseFrame;

@end

@implementation ParallaxForegroundView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.houseViews = [NSMutableArray array];
        HouseView *house = [[HouseView alloc] init];
        self.houseFrame = house.frame;
    }
    return self;
}

- (void)setup {
    self.scrollView.contentSize = self.frame.size;
    [self refreshHouses];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHouses) name:UserDataHouseDataChangedNotification object:nil];
}

- (void)refreshHouses {
    // clean out old houses
    [self.houseViews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self.houseViews removeAllObjects];
    
    NSArray *housesData = [UserData instance].houses;
    
    HouseView *house;
    for (HouseData *data in housesData) {
        house = [[HouseView alloc] init];
        [self.scrollView addSubview:house];
        [self.houseViews addObject:house];
        [house setupWithData:data];
    }
    
    [self layoutHouses];
}

- (void)layoutHouses {
    CGFloat spacing = self.houseFrame.size.width * 0.5f;
    CGFloat xOffset = spacing;

    for (HouseView *house in self.houseViews) {
        house.y = self.height - self.houseFrame.size.height;
        house.x = xOffset;
        xOffset += house.width + spacing;
    }
}

- (HouseView *)firstEmptyHouseUnder:(int)rooms {    
    HouseView *firstEmptyHouse = [self.houseViews randomObject];
    for (HouseView *house in self.houseViews) {
        if (!house.data.renterData && house.data.unitSize >= rooms) {
            firstEmptyHouse = house;
            break;
        }
    }
    return firstEmptyHouse;
}


@end

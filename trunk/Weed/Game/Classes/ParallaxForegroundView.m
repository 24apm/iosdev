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
#import "RealEstateManager.h"

@interface ParallaxForegroundView()

@property (strong, nonatomic) NSMutableArray *houseViews;
@property (nonatomic) CGRect houseFrame;

@end

@implementation ParallaxForegroundView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        HouseView *house = [[HouseView alloc] init];
        self.houseFrame = house.frame;
    }
    return self;
}

- (void)setup {
    self.scrollView.contentSize = self.frame.size;
    self.houseViews = [NSMutableArray array];
    for (int i = 0; i < MAX_HOUSES; i++) {
        HouseView *house = [[HouseView alloc] init];
        [self.scrollView addSubview:house];
        [self.houseViews addObject:house];
    }
    
    [self refreshHouses];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHouses) name:UserDataHouseDataChangedNotification object:nil];
}

- (void)refreshHouses {
    NSArray *housesData = [UserData instance].houses;
    
    for (int i = 0; i < self.houseViews.count; i++) {
        HouseView *house = [self.houseViews objectAtIndex:i];
        if (i < housesData.count) {
            [house setupWithData:[housesData objectAtIndex:i]];
            house.hidden = NO;
        } else {
            [house cleanedUp];
            house.hidden = YES;
        }
    }
    
    [self layoutHouses];
}

- (void)layoutHouses {
    CGFloat spacing = 0;//self.houseFrame.size.width * 0.5f;
    CGFloat xOffset = spacing;

    for (HouseView *house in self.houseViews) {
        house.y = self.height - self.houseFrame.size.height;
//        house.y = self.center.y - self.height / 2.f;
        house.x = xOffset;
        xOffset += house.width + spacing;
    }
}

- (HouseView *)firstEmptyHouseUnder:(int)rooms {
    NSMutableArray *availableHouseViews = [self allVisibleHouses];
    
    // Look for first empty house AND fit room size
    HouseView *firstEmptyHouse = nil;
    for (HouseView *house in availableHouseViews) {
        if (!house.data.renterData && house.data.unitSize >= rooms) {
            firstEmptyHouse = house;
            break;
        }
    }
    
    // Look for fit room size
    if (!firstEmptyHouse) {
        for (HouseView *house in availableHouseViews) {
            if (house.data.unitSize >= rooms) {
                firstEmptyHouse = house;
                break;
            }
        }
    }
    
    // Put random one if nothing was found
    if (!firstEmptyHouse) {
        firstEmptyHouse = [availableHouseViews randomObject];
    }
    return firstEmptyHouse;
}

- (HouseView *)firstCollectableHouse {
    NSMutableArray *availableHouseViews = [self allVisibleHouses];
    
    // Look for first empty house AND fit room size
    HouseView *firstEmptyHouse = nil;
    for (HouseView *house in availableHouseViews) {
        if ([[RealEstateManager instance] canCollectMoney:house.data]) {
            firstEmptyHouse = house;
            break;
        }
    }
    if (!firstEmptyHouse) {
        firstEmptyHouse = [availableHouseViews randomObject];
    }
    return firstEmptyHouse;
}

- (NSMutableArray *)allVisibleHouses {
    NSMutableArray *availableHouseViews = [NSMutableArray array];
    for (HouseView *house in self.houseViews) {
        if (!house.hidden) {
            [availableHouseViews addObject:house];
        }
    }
    return availableHouseViews;
}


@end

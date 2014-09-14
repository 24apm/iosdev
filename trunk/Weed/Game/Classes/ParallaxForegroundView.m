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
#import "VisitorManager.h"

@interface ParallaxForegroundView()

@property (strong, nonatomic) IBOutlet UIView *contentView;
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
    for (VisitorView *visitor in self.vistorCollection) {
        visitor.hidden = YES;
    }
    self.scrollView.contentSize = self.contentView.frame.size;
    self.scrollView.delaysContentTouches = YES;
    self.houseViews = [NSMutableArray array];
    for (int i = 0; i < MAX_HOUSES; i++) {
        HouseView *house = [[HouseView alloc] init];
        [self.scrollView addSubview:house];
        [self.houseViews addObject:house];
    }
    [self refreshVisitors];
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
    
    // Look for first empty house AND exact fit room size
    HouseView *firstEmptyHouse = nil;
    for (HouseView *house in availableHouseViews) {
        if (!house.data.renterData && house.data.unitSize == rooms) {
            firstEmptyHouse = house;
            break;
        }
    }
    
    // Look for 1st empty AND greater fit room size
    if (!firstEmptyHouse) {
        for (HouseView *house in availableHouseViews) {
            if (!house.data.renterData && house.data.unitSize >= rooms) {
                firstEmptyHouse = house;
                break;
            }
        }
    }
    
    // Look for greater fit room size
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

- (HouseView *)newestHouse {
    NSMutableArray *availableHouseViews = [self allVisibleHouses];
    HouseView *house = [availableHouseViews lastObject];
    return house;
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

- (void)refreshVisitors {
    NSMutableArray *emptyVisitors = [NSMutableArray array];
    for (VisitorView *visitor in self.vistorCollection) {
        if (visitor.data == nil) {
            [emptyVisitors addObject:visitor];
        }
    }
    if (emptyVisitors.count > 0) {
        VisitorView *randVisitor = [emptyVisitors randomObject];
        VisitorData *data = [[VisitorManager instance] nextVisitor];
        [randVisitor setupWithData:data];
        [randVisitor animateIn];
    }
    
    float delay = [Utils randBetweenMin:1 max:5];
    [self performSelector:@selector(refreshVisitors) withObject:nil afterDelay:delay];
}
@end

//
//  ParallaxForegroundView.m
//  Weed
//
//  Created by MacCoder on 7/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ParallaxForegroundView.h"
#import "UpgradeResultView.h"
#import "HouseView.h"

@interface ParallaxForegroundView()

@property (strong, nonatomic) NSMutableArray *houses;
@property (nonatomic) CGRect houseFrame;

@end

@implementation ParallaxForegroundView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.houses = [NSMutableArray array];
        HouseView *house = [[HouseView alloc] init];
        self.houseFrame = house.frame;
    }
    return self;
}

- (void)setup {
    self.scrollView.contentSize = self.frame.size;

    HouseView *house;
    for (int i = 0; i < 10; i++) {
        house = [[HouseView alloc] init];
        [self.scrollView addSubview:house];
        [self.houses addObject:house];
        [house setup];
    }
    [self layoutHouses];
}

- (void)layoutHouses {
    CGFloat spacing = self.houseFrame.size.width * 0.5f;
    CGFloat xOffset = spacing;

    for (HouseView *house in self.houses) {
        house.y = self.height - self.houseFrame.size.height;
        house.x = xOffset;
        xOffset += house.width + spacing;
    }
}

- (IBAction)testPressed:(id)sender {
    [[[UpgradeResultView alloc] init] showSuccess];

}

@end

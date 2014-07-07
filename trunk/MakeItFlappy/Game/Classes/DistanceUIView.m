//
//  DistanceUIView.m
//  Make It Flappy
//
//  Created by MacCoder on 6/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "DistanceUIView.h"

@implementation DistanceUIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self show];
    }
    return self;
}

- (void)show {
    self.distanceImage.hidden = NO;
    self.currentDistanceLabel.hidden = NO;
    self.spsLabel.hidden = NO;
}

- (void)hide {
    self.distanceImage.hidden = YES;
    self.currentDistanceLabel.hidden = YES;
    self.spsLabel.hidden = YES;
}


@end

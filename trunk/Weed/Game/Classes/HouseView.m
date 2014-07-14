//
//  HouseView.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "HouseView.h"
#import "Utils.h"
#import "GameLoopTimer.h"
#import "UserData.h"

@interface HouseView()

@property (nonatomic) double expiredTime;
@property (nonatomic) double timerDuration;

@end

@implementation HouseView

- (void)setup {
    self.state = HouseViewStateInProgress;
    [self refresh];
    self.timerDuration = 5;
    
    self.expiredTime = CURRENT_TIME + self.timerDuration;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawStep) name:DRAW_STEP_NOTIFICATION object:nil];
}

- (void)drawStep {
    double percentage = (self.expiredTime - CURRENT_TIME) / self.timerDuration;
    [self.progressBar fillBar:1 - percentage];
}

- (void)refresh {
    self.inProgressView.hidden = YES;
    self.completedView.hidden = YES;
    
    switch (self.state) {
        case HouseViewStateInProgress:
            self.inProgressView.hidden = NO;
            break;
        case HouseViewStateCompleted:
            self.completedView.hidden = NO;
            break;
        default:
            break;
    }
}

- (IBAction)buttonPressed:(id)sender {
    if (CURRENT_TIME > self.expiredTime) {
        self.expiredTime = CURRENT_TIME + self.timerDuration;
        [[UserData instance] incrementCoin:30];
    }
}

@end

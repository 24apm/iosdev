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
#import "Utils.h"
#import "RealEstateManager.h"

@interface HouseView()

@end

@implementation HouseView

- (void)setupWithData:(HouseData *)data {
    self.data = data;
    
    [self refresh];
    
    self.idLabel.text = [NSString stringWithFormat:@"%d", self.data.id];
    
    [self.buttonView setBackgroundImage:[UIImage imageNamed:self.data.imagePath] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:DRAW_STEP_NOTIFICATION object:nil];
}

- (void)refresh {
    double timeLeft = self.data.renterData.timeDue - CURRENT_TIME;
    double percentage = 1.f - timeLeft / self.data.renterData.duration;
    
    if (self.data.renterData) {
        if (percentage < 1.f) {
            self.state = HouseViewStateInProgress;
        } else {
            self.state = HouseViewStateCompleted;
        }
    } else {
        self.state = HouseViewStateEmpty;
    }
    
    self.emptyView.hidden = YES;
    self.inProgressView.hidden = YES;
    self.completedView.hidden = YES;
    
    switch (self.state) {
        case HouseViewStateEmpty:
            self.emptyView.hidden = NO;
            break;
        case HouseViewStateInProgress:
            self.inProgressView.hidden = NO;
            
            percentage = CLAMP(percentage, 0, 1.f);
            [self.progressBar fillBar:percentage];
            self.timeLabel.text = [Utils formatTime:timeLeft];
            break;
        case HouseViewStateCompleted:
            self.completedView.hidden = NO;
            break;
        default:
            break;
    }
}

- (IBAction)buttonPressed:(id)sender {
    switch (self.state) {
        case HouseViewStateEmpty:
            break;
        case HouseViewStateInProgress:
            break;
        case HouseViewStateCompleted:
            [[RealEstateManager instance] collectMoney:self.data];
            break;
        default:
            break;
    }
}

- (void)removeFromSuperview {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
}

@end
